# consumer_groups — partition sharing across consumers

One topic (6 partitions), three consumers in the same group.

```bash
cd apache/kafka/consumer_groups
cp .env.example .env
docker compose up -d
# produce test traffic
docker compose --profile tools run --rm producer
# watch each consumer get a subset of partitions
docker compose logs -f consumer-a consumer-b consumer-c
docker compose down -v
```
