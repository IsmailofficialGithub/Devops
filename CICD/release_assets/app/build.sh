#!/usr/bin/env bash
set -euo pipefail
mkdir -p out
echo "release payload $(date -u +%Y-%m-%dT%H:%M:%SZ)" > out/app.txt
tar -czf "out/app-${GITHUB_REF_NAME:-local}.tar.gz" -C out app.txt
