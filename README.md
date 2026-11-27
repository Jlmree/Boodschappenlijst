# Boodschappenlijst

Makkelijke gedeelde boodschappenlijst voor het hele gezin. Werkt op Android en iPhone, ook offline, zonder account.

**Live:** https://jlmree.github.io/Boodschappenlijst/

## Wat kan het

- Meerdere lijsten (bijv. AH, Lidl, Action), elk met eigen kleur en looproute door de winkel
- Snel toevoegen: `2 melk, brood en kaas` wordt drie artikelen, al ingedeeld per afdeling
- Tik op een artikel om af te vinken, houd ingedrukt voor details, veeg naar links om te verwijderen
- Aantal als label (2× Melk, 500 g Gehakt, 1,5 kg Aardappels); − / + telt per stuk, per 100 g of per 0,5 kg
- Eenheid kiezen in de details (stuks, gram, kilo, liter, pak…); de app onthoudt per product de laatste hoeveelheid
- Tegelijk tikken door meerdere gezinsleden telt netjes op
- Vaste items, suggesties uit wat je vaak koopt, inspreken met de microfoon
- "Ik ga winkelen": de rest ziet dat je in de winkel bent; "Klaar met winkelen" ruimt de gehaalde artikelen op
- Eigen afdelingen toevoegen (bijv. Drogist) en de looproute per winkel instellen
- Live samen via een gezinslink, je ziet wie iets toevoegde of haalde
- Offline: wijzigingen wachten en worden verstuurd zodra er weer bereik is
- Op je beginscherm te zetten als app

## Delen aanzetten (eenmalig, ±5 minuten, gratis)

Zonder deze stappen werkt de app alleen op één toestel.

1. Maak een gratis account op [supabase.com](https://supabase.com) en klik **New project** (regio: bijv. Frankfurt). Kies een databasewachtwoord en bewaar het.
2. Ga in het project naar **SQL Editor → New query**, plak de inhoud van [`supabase.sql`](supabase.sql) en klik **Run**.
3. Ga naar **Project Settings → API** (of **Connect**) en kopieer:
   - de **Project URL** (`https://….supabase.co`)
   - de **anon public** / **publishable** key
4. Vul die twee in [`config.js`](config.js) in en commit.
5. Open de app, kies **Nieuw gezin starten**, vul je naam in en deel de link via het delen-icoon.

## Hoe veilig is het?

- Iedereen met de gezinslink kan meedoen: deel hem alleen met je gezin.
- De gezinscode is 12 willekeurige tekens. De database laat alleen wie die code kent bij jullie lijst (getest: een ander gezin ziet en wijzigt niets).
- De anon-sleutel in `config.js` mag openbaar zijn; hij geeft zonder code nergens toegang toe.
- Prototype: geen accounts. Inloggen per gezinslid kan later worden toegevoegd.

## Bestanden

| Bestand | Wat |
|---|---|
| `index.html` | De hele app |
| `config.js` | Koppeling met Supabase |
| `supabase.sql` | Database-opzet (tabel, beveiliging, samenvoegen) |
| `sw.js`, `manifest.webmanifest`, `icon*` | Offline en installeerbaar maken |
