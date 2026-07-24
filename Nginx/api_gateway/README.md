# api_gateway — path-based reverse proxy + method allow-list

```bash
cp .env.example .env
docker compose up -d
curl http://localhost:${HTTP_PORT}/users/
curl http://localhost:${HTTP_PORT}/orders/
```
