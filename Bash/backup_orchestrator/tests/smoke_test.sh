#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
chmod +x bin/*.sh lib/*.sh 2>/dev/null || true
cp -n config/env.example config/.env || true
cp -n config/targets.example.conf config/targets.conf || true
mkdir -p /tmp/bo-src /tmp/bo-backups
echo "payload-$(date +%s)" > /tmp/bo-src/file.txt
# force backup root for test
export BACKUP_ROOT=/tmp/bo-backups
export TARGETS_FILE="$ROOT_DIR/config/targets.conf"
./bin/backup.sh --target demo
./bin/verify.sh --target demo
./bin/prune.sh --target demo --dry-run
rm -rf /tmp/bo-restore
./bin/restore.sh --target demo --latest --dest /tmp/bo-restore
test -f /tmp/bo-restore/bo-src/file.txt || test -f /tmp/bo-restore/file.txt
echo "smoke_test OK"
