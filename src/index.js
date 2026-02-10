export default {
    async fetch(request, env, ctx) {
          const url = new URL(request.url);

      // Serve the landing page HTML from GitHub
      const ghUrl = 'https://raw.githubusercontent.com/iwanderph20-art/relationcheck-landing/main/index.html';

      // Check cache first
      const cache = caches.default;
          const cacheKey = new Request(url.origin + '/index.html');
          let response = await cache.match(cacheKey);

      if (!response) {
              const ghRes = await fetch(ghUrl);
              const html = await ghRes.text();
              response = new Response(html, {
                        headers: {
                                    'Content-Type': 'text/html;charset=UTF-8',
                                    'Cache-Control': 'public, max-age=3600'
                        }
              });
              ctx.waitUntil(cache.put(cacheKey, response.clone()));
      }

      return response;
    }
}
