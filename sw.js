const CACHE = 'migasto-v202606011200';
const ASSETS = ['./', './index.html', './manifest.json'];

self.addEventListener('install', e => {
  e.waitUntil(
    caches.open(CACHE).then(c => c.addAll(ASSETS)).then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

// Para el botón "Actualizar" de la app
self.addEventListener('message', e => {
  if (e.data && e.data.type === 'SKIP_WAITING') self.skipWaiting();
});

self.addEventListener('fetch', e => {
  if (e.request.method !== 'GET' || !e.request.url.startsWith(self.location.origin)) return;

  // index.html y raíz: SIEMPRE red primero, sin caché HTTP
  if (e.request.url.endsWith('/') || e.request.url.includes('index.html') || e.request.url.includes('?v=')) {
    e.respondWith(
      fetch(new Request(e.request.url.split('?')[0], { cache: 'no-store' }))
        .then(res => {
          const clone = res.clone();
          caches.open(CACHE).then(c => c.put(new Request(e.request.url.split('?')[0]), clone));
          return res;
        })
        .catch(() => caches.match(new Request(e.request.url.split('?')[0])))
    );
    return;
  }

  // Resto: caché primero, red como fallback (solo cachear respuestas exitosas)
  e.respondWith(
    caches.match(e.request).then(cached => cached || fetch(e.request).then(res => {
      if(res.ok) {
        const clone = res.clone();
        caches.open(CACHE).then(c => c.put(e.request, clone));
      }
      return res;
    }))
  );
});
