#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
chmod +x bin/*.sh lib/*.sh 2>/dev/null || true
cp -n config/env.example config/.env || true
cp -n config/checks.example.conf config/checks.conf || true
# process+disk should pass; http to :9 likely fails — ensure script runs
./bin/check_once.sh || true
./bin/watchdog.sh --loops 2 --interval 1
test -f out/alerts.log
echo "smoke_test OK"
