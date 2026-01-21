#!/usr/bin/env bash
set -euo pipefail

SMOKE="${GOPATH:-$HOME/go}/bin/smoke"

if ! command -v "$SMOKE" &>/dev/null; then
    echo "smoke not found, installing..."
    go install -v github.com/chakrit/smoke@latest
fi

"$SMOKE" tests.yml "$@"
