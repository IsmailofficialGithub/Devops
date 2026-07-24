# log_analyzer

Large Bash toolkit to analyze web/app logs: top IPs, status codes, slow paths, error bursts, and reports.

## Layout

```
log_analyzer/
  bin/analyze.sh          # main CLI
  bin/tail_alerts.sh      # follow logs and alert on patterns
  lib/common.sh           # logging, args, colors
  lib/parsers.sh          # nginx/apache/json line parsers
  lib/report.sh           # markdown/html/json writers
  config/env.example
  examples/sample.access.log
  tests/smoke_test.sh
```

## Quick start

```bash
cd Bash/log_analyzer
cp config/env.example config/.env
chmod +x bin/*.sh tests/*.sh lib/*.sh
./bin/analyze.sh --input examples/sample.access.log --format md --out /tmp/report.md
./bin/analyze.sh --input examples/sample.access.log --format json --out /tmp/report.json
./bin/tail_alerts.sh --input examples/sample.access.log --once
./tests/smoke_test.sh
```
