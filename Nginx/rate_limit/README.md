# rate_limit — request + connection limiting reverse proxy

```bash
cp .env.example .env
docker compose up -d
# hammer to see 503:
# for i in $(seq 1 50); do curl -s -o /dev/null -w "%{http_code}\n" http://localhost:${HTTP_PORT}/; done
```
