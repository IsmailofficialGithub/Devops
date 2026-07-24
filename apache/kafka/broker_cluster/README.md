# broker_cluster — multi-broker KRaft Kafka

Three Kafka nodes (no ZooKeeper). Controllers + brokers in KRaft mode.

```bash
cd apache/kafka/broker_cluster
cp .env.example .env
docker compose up -d
docker compose ps
docker compose exec kafka-1 /opt/kafka/bin/kafka-topics.sh \
  --bootstrap-server kafka-1:9092 \
  --create --topic demo-cluster --partitions 6 --replication-factor 3
docker compose exec kafka-1 /opt/kafka/bin/kafka-topics.sh \
  --bootstrap-server kafka-1:9092 --describe --topic demo-cluster
docker compose down -v
```
