# Nginx — 8 scenario projects

Each folder is one project. Config is driven by `.env` (copy from `.env.example`).

Official `nginx` image auto-runs `envsubst` on `templates/*.template` → `/etc/nginx/conf.d/`.

## Prerequisites

- Docker + Docker Compose
- OpenSSL (only for `ssl_termination`)

## Shared pattern

```
<project>/
  .env.example
  docker-compose.yml
  templates/default.conf.template
  html/          # static files (if needed)
  certs/         # TLS (ssl_termination only)
```

## Ports overview

| Project | HTTP | HTTPS |
|---|---|---|
| reverse_proxy | 8080 | — |
| load_balancer | 8081 | — |
| streaming | 8082 | — |
| api_gateway | 8083 | — |
| portfolio | 8084 | — |
| ssl_termination | 8085 | 8443 |
| rate_limit | 8086 | — |
| cache_proxy | 8087 | — |

---

## How to run every project

### 1. reverse_proxy

Basic reverse proxy to one backend.

```bash
cd Nginx/reverse_proxy
cp .env.example .env
docker compose up -d
curl http://localhost:8080/
curl http://localhost:8080/health
docker compose down
```

### 2. load_balancer

Upstream pool — change strategy in `.env`:

- `LB_METHOD=least_conn;`
- `LB_METHOD=ip_hash;`
- `LB_METHOD=` (empty = round-robin)

```bash
cd Nginx/load_balancer
cp .env.example .env
docker compose up -d
curl http://localhost:8081/
# hit a few times — responses rotate across backend-1/2/3
docker compose down
```

### 3. streaming

WebSocket (`/ws`, `/socket.io`) + media (`/stream`) reverse proxy.

```bash
cd Nginx/streaming
cp .env.example .env
docker compose up -d
curl http://localhost:8082/
curl http://localhost:8082/ws/
docker compose down
```

### 4. api_gateway

Path-based routing to users / orders / auth services.

```bash
cd Nginx/api_gateway
cp .env.example .env
docker compose up -d
curl http://localhost:8083/users/
curl http://localhost:8083/orders/
curl http://localhost:8083/auth/
curl http://localhost:8083/health
docker compose down
```

### 5. portfolio

Static SPA hosting with security headers.

```bash
cd Nginx/portfolio
cp .env.example .env
docker compose up -d
curl http://localhost:8084/
# open http://localhost:8084/ in a browser
docker compose down
```

### 6. ssl_termination

HTTPS at Nginx, HTTP to backend. Generate self-signed certs first:

```bash
cd Nginx/ssl_termination
openssl req -x509 -nodes -days 365 -newkey rsa:2048 `
  -keyout certs/privkey.pem -out certs/fullchain.pem `
  -subj "/CN=secure.local"
cp .env.example .env
docker compose up -d
curl -k https://localhost:8443/
curl -I http://localhost:8085/
# expect 301 redirect to HTTPS
docker compose down
```

### 7. rate_limit

Request + connection limiting (`429` when exceeded).

```bash
cd Nginx/rate_limit
cp .env.example .env
docker compose up -d
curl http://localhost:8086/
# burst requests to trigger 429:
1..50 | ForEach-Object { curl -s -o NUL -w "%{http_code}`n" http://localhost:8086/ }
docker compose down
```

### 8. cache_proxy

Caching reverse proxy — check `X-Cache-Status` (`MISS` then `HIT`).

```bash
cd Nginx/cache_proxy
cp .env.example .env
docker compose up -d
curl -I http://localhost:8087/
curl -I http://localhost:8087/
# second response should show X-Cache-Status: HIT
docker compose down
```

---

## Useful commands (any project)

```bash
# logs
docker compose logs -f nginx

# reload after editing .env / templates
docker compose up -d --force-recreate nginx

# stop
docker compose down
```

Tune hosts, ports, timeouts, LB method, rate limits, and cache TTLs in each project’s `.env`.
