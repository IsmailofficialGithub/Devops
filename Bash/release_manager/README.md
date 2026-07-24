# release_manager

Semver release toolkit: bump version, changelog entry, build artifact, promote environments, rollback pointer.

## Layout

```
release_manager/
  bin/bump.sh
  bin/changelog.sh
  bin/build.sh
  bin/promote.sh
  bin/rollback.sh
  lib/common.sh
  lib/semver.sh
  lib/gitmeta.sh
  config/env.example
  VERSION
  CHANGELOG.md
  tests/smoke_test.sh
```

## Quick start

```bash
cd Bash/release_manager
cp config/env.example config/.env
chmod +x bin/*.sh lib/*.sh tests/*.sh
./bin/bump.sh --part patch
./bin/changelog.sh --message "demo release notes"
./bin/build.sh
./bin/promote.sh --env staging
./bin/rollback.sh --env staging
```
