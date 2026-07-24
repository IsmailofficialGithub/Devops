#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
chmod +x bin/*.sh lib/*.sh 2>/dev/null || true
cp -n config/env.example config/.env || true
./bin/analyze.sh --input examples/sample.access.log --format md --out /tmp/la-report.md
./bin/analyze.sh --input examples/sample.access.log --format json --out /tmp/la-report.json
./bin/tail_alerts.sh --input examples/sample.access.log --once | grep -q ALERT
echo "smoke_test OK"
