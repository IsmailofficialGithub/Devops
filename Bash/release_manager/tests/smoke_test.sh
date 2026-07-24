#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
chmod +x bin/*.sh lib/*.sh 2>/dev/null || true
cp -n config/env.example config/.env || true
./bin/bump.sh --part patch
./bin/changelog.sh --message "smoke test release"
./bin/build.sh
./bin/promote.sh --env staging
./bin/bump.sh --part patch
./bin/build.sh
./bin/promote.sh --env staging
./bin/rollback.sh --env staging
echo "smoke_test OK"
