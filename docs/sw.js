// MonsterMatch service worker: network first, cache fallback.
// Build-PWA.ps1 sets the cache version on each build.

const CACHE_NAME = "monstermatch-20261022-051036";

self.addEventListener("install", () => {
  self.skipWaiting();
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys()
      .then((names) => Promise.all(
        names
          .filter((name) => name.startsWith("monstermatch-") && name !== CACHE_NAME)
          .map((name) => caches.delete(name))
      ))
      .then(() => self.clients.claim())
  );
});

// Revalidate every request so a new build shows up on the next load.
// Navigation requests can't take init options, so rebuild them from the URL.
function fetchFresh(request) {
  if (request.mode === "navigate") {
    return fetch(new Request(request.url, { cache: "no-cache" }));
  }
  return fetch(request, { cache: "no-cache" });
}

self.addEventListener("fetch", (event) => {
  const request = event.request;

  // Same-origin GETs only
  if (request.method !== "GET" || new URL(request.url).origin !== self.location.origin) {
    return;
  }

  event.respondWith(
    fetchFresh(request)
      .then((response) => {
        // Partial (206) responses can't be cached
        if (response.status === 200) {
          const copy = response.clone();
          caches.open(CACHE_NAME).then((cache) => cache.put(request, copy)).catch(() => {});
        }
        return response;
      })
      .catch(() => caches.match(request, { ignoreSearch: true }))
  );
});
