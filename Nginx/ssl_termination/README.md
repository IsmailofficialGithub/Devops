# ssl_termination — HTTPS at Nginx, HTTP to backends

Place certs in `certs/fullchain.pem` and `certs/privkey.pem`, or generate self-signed:

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout certs/privkey.pem -out certs/fullchain.pem \
  -subj "/CN=secure.local"
cp .env.example .env
docker compose up -d
curl -k https://localhost:${HTTPS_PORT}/
```
