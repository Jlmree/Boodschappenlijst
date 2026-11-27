-- Boodschappen samen: database-opzet voor Supabase.
-- Plak dit in Supabase > SQL Editor > New query en klik op Run.
-- Veilig om opnieuw te draaien.

create table if not exists public.docs (
  household  text not null check (household ~ '^[a-z0-9]{8,32}$'),
  coll       text not null check (coll in ('lists','items','known','pings','members')),
  id         text not null check (length(id) between 1 and 80),
  data       jsonb not null check (length(data::text) < 300000),
  updated_at timestamptz not null default now(),
  primary key (household, coll, id)
);

-- Gezinscode komt mee als header 'x-household'.
create or replace function public.req_household() returns text
language sql stable as $$
  select coalesce(current_setting('request.headers', true)::json->>'x-household', '')
$$;

alter table public.docs enable row level security;

drop policy if exists gezin_lezen   on public.docs;
drop policy if exists gezin_maken   on public.docs;
drop policy if exists gezin_wijzig  on public.docs;
drop policy if exists gezin_wissen  on public.docs;
create policy gezin_lezen  on public.docs for select to anon using (household = public.req_household());
create policy gezin_maken  on public.docs for insert to anon with check (household = public.req_household());
create policy gezin_wijzig on public.docs for update to anon using (household = public.req_household()) with check (household = public.req_household());
create policy gezin_wissen on public.docs for delete to anon using (household = public.req_household());

grant select, insert, update, delete on public.docs to anon;

-- Samenvoegen zonder conflicten (bijv. tegelijk op + tikken):
-- objecten in de patch worden één niveau diep samengevoegd.
create or replace function public.merge_doc(p_coll text, p_id text, p_patch jsonb)
returns jsonb language plpgsql security invoker as $$
declare r jsonb;
begin
  update public.docs d
     set data = d.data || (
           select coalesce(jsonb_object_agg(k,
                    case when jsonb_typeof(v) = 'object' and jsonb_typeof(d.data->k) = 'object'
                         then (d.data->k) || v else v end), '{}'::jsonb)
             from jsonb_each(p_patch) as e(k, v)),
         updated_at = now()
   where d.household = public.req_household() and d.coll = p_coll and d.id = p_id
  returning d.data into r;
  return r;
end $$;

grant execute on function public.merge_doc(text, text, jsonb) to anon;
