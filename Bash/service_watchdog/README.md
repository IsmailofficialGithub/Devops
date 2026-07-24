# service_watchdog

Multi-check health monitor: HTTP, TCP, process, disk, and optional restart hooks with cooldown + alert log.

## Layout

```
service_watchdog/
  bin/watchdog.sh
  bin/check_once.sh
  lib/common.sh
  lib/checks.sh
  lib/actions.sh
  config/env.example
  config/checks.example.conf
  tests/smoke_test.sh
```

## Quick start

```bash
cd Bash/service_watchdog
cp config/env.example config/.env
cp config/checks.example.conf config/checks.conf
chmod +x bin/*.sh lib/*.sh tests/*.sh
./bin/check_once.sh
./bin/watchdog.sh --loops 3 --interval 2
```
