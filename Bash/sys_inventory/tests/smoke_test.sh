#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
chmod +x bin/*.sh lib/*.sh 2>/dev/null || true
cp -n config/env.example config/.env || true
f1="$(./bin/collect.sh --out ./out/inv1.json)"
./bin/report.sh --input "$f1" --format md --out ./out/inv1.md
f2="$(./bin/collect.sh --out ./out/inv2.json)"
./bin/diff_inventory.sh --a "$f1" --b "$f2" >/dev/null
test -f ./out/inv1.md
echo "smoke_test OK"
