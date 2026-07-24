# cache_proxy — caching reverse proxy

```bash
cp .env.example .env
docker compose up -d
curl -I http://localhost:${HTTP_PORT}/
# Check X-Cache-Status: MISS then HIT
```
