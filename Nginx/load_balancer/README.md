# load_balancer — upstream pool with selectable strategy

```bash
cp .env.example .env
# set LB_METHOD=least_conn; | ip_hash; | empty for round-robin
docker compose up -d
curl http://localhost:${HTTP_PORT}/
```
