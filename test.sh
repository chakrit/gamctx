#!/usr/bin/env bash
set -euo pipefail

if ! command -v smoke &>/dev/null; then
    echo "smoke not found, installing..."
    go install -v github.com/chakrit/smoke@latest
fi

smoke tests.yml "$@"
