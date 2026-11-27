// Offline: app-bestanden bewaren. Pagina eerst van het netwerk (updates),
// bij geen bereik uit de cache. Database-verkeer gaat nooit via de cache.
const CACHE = "boodschappen-v1";
const SHELL = ["./", "index.html", "config.js", "manifest.webmanifest", "icon.svg", "icon-192.png"];
const LIB = "https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2";

self.addEventListener("install", e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(SHELL).then(() => c.add(LIB).catch(() => {}))));
  self.skipWaiting();
});
self.addEventListener("activate", e => {
  e.waitUntil(caches.keys().then(ks => Promise.all(ks.filter(k => k !== CACHE).map(k => caches.delete(k)))).then(() => self.clients.claim()));
});
self.addEventListener("fetch", e => {
  const req = e.request;
  if (req.method !== "GET") return;
  const url = new URL(req.url);
  if (url.hostname.endsWith("supabase.co") || url.hostname.endsWith("supabase.in")) return;
  const isLib = req.url.startsWith(LIB);
  const isFont = url.hostname.includes("fonts.g");
  if (url.origin !== location.origin && !isLib && !isFont) return;
  if (isLib || isFont) {
    e.respondWith(caches.match(req).then(hit => hit || fetch(req).then(r => { const cp = r.clone(); caches.open(CACHE).then(c => c.put(req, cp)); return r; })));
    return;
  }
  e.respondWith(fetch(req).then(r => {
    if (r.ok) { const cp = r.clone(); caches.open(CACHE).then(c => c.put(req, cp)); }
    return r;
  }).catch(() => caches.match(req, { ignoreSearch: true }).then(hit => hit || caches.match("index.html"))));
});
