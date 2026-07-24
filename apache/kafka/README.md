# Apache Kafka — 3 scenario projects

Folder name = project name. Each project is env-driven (`cp .env.example .env`).

| Folder | Scenario |
|---|---|
| `broker_cluster` | Multi-broker KRaft cluster |
| `producer_consumer` | Produce messages → consume from a topic |
| `consumer_groups` | Same group, multiple consumers (partition sharing) |

## Run any project

```bash
cd apache/kafka/<project>
cp .env.example .env
docker compose up -d
```

See each folder’s `README.md` for commands.
