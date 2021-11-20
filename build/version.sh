#!/usr/bin/env bash
set -Eeuo pipefail

if [ "${CI:-false}" == "true" ]; then
    # CI, therefore real
    echo "$(date --universal '+%Y-%m-%d')-$(git rev-parse --short HEAD)"
else
    # testing
    echo "$(date --universal '+%s')-$(git rev-parse --short HEAD)-test"
fi
