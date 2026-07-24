# sys_inventory

Collect host inventory (OS, CPU, memory, disk, network, listening ports, packages) and emit JSON + Markdown reports.

## Layout

```
sys_inventory/
  bin/collect.sh
  bin/report.sh
  bin/diff_inventory.sh
  lib/common.sh
  lib/collectors.sh
  lib/formatters.sh
  config/env.example
  tests/smoke_test.sh
```

## Quick start

```bash
cd Bash/sys_inventory
cp config/env.example config/.env
chmod +x bin/*.sh lib/*.sh tests/*.sh
./bin/collect.sh --out ./out/inventory.json
./bin/report.sh --input ./out/inventory.json --format md --out ./out/inventory.md
./bin/collect.sh --out ./out/inventory2.json
./bin/diff_inventory.sh --a ./out/inventory.json --b ./out/inventory2.json
```
