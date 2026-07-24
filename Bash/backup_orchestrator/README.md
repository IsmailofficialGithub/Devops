# backup_orchestrator

Multi-target backup toolkit: archive, checksum, retention prune, restore, and dry-run plans.

## Layout

```
backup_orchestrator/
  bin/backup.sh
  bin/restore.sh
  bin/prune.sh
  bin/verify.sh
  lib/common.sh
  lib/archive.sh
  lib/retention.sh
  config/env.example
  config/targets.example.conf
  tests/smoke_test.sh
```

## Quick start

```bash
cd Bash/backup_orchestrator
cp config/env.example config/.env
cp config/targets.example.conf config/targets.conf
mkdir -p /tmp/bo-src /tmp/bo-backups
echo hello > /tmp/bo-src/file.txt
# edit targets.conf paths if needed
chmod +x bin/*.sh lib/*.sh tests/*.sh
./bin/backup.sh --target demo
./bin/verify.sh --target demo
./bin/prune.sh --target demo --dry-run
./bin/restore.sh --target demo --latest --dest /tmp/bo-restore
```
