const CACHE_NAME = 'tlf-webr-v1';
const COOP_HEADER = 'same-origin';
const COEP_HEADER = 'require-corp';

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => cache.addAll([
      '/', '/src/main.js', '/src/app.R', '/src/styles.css'
    ]).catch(err => console.warn('Cache addAll failed:', err)))
  );
  self.skipWaiting();
});

self.addEventListener('activate', event => event.waitUntil(clients.claim()));

self.addEventListener('fetch', event => {
  const url = new URL(event.request.url);
  if (url.origin !== location.origin) return;

  event.respondWith(
    caches.match(event.request).then(cached => {
      const fetchPromise = fetch(event.request).then(networkResponse => {
        const headers = new Headers(networkResponse.headers);
        headers.set('Cross-Origin-Opener-Policy', COOP_HEADER);
        headers.set('Cross-Origin-Embedder-Policy', COEP_HEADER);
        const modified = new Response(networkResponse.body, {
          status: networkResponse.status,
          statusText: networkResponse.statusText,
          headers
        });
        if (networkResponse.ok) {
          caches.open(CACHE_NAME).then(cache => cache.put(event.request, modified.clone()));
        }
        return modified;
      }).catch(() => cached);
      return fetchPromise;
    })
  );
});

self.addEventListener('message', event => {
  if (event.data === 'skipWaiting') self.skipWaiting();
});
