# Bash — 5 large DevOps scripting projects

| Folder | What it does |
|---|---|
| `log_analyzer` | Parse access/error logs, top talkers, error spikes, HTML/JSON reports |
| `backup_orchestrator` | Multi-target backups, checksums, retention, restore |
| `service_watchdog` | HTTP/TCP/disk/process checks, alerts, optional restart |
| `release_manager` | Semver bump, changelog, build/tag, promote, rollback |
| `sys_inventory` | Host inventory → JSON + Markdown report |

## Run a project

```bash
cd Bash/<project>
cp config/env.example config/.env
chmod +x bin/*.sh
./bin/<main-script>.sh --help
```

See each project `README.md` for full flows.
