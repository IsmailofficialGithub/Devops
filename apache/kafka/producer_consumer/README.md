# producer_consumer — produce then consume a topic

Single KRaft broker + `kcat` producer/consumer one-shots.

```bash
cd apache/kafka/producer_consumer
cp .env.example .env
docker compose up -d
# wait until kafka is healthy, then:
docker compose --profile tools run --rm producer
docker compose --profile tools run --rm consumer
docker compose down -v
```
