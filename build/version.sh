#!/usr/bin/env bash
set -Eeuo pipefail

if [ "${CI:-false}" == "true" ]; then
    if [ -n "${PR:-}" ]; then
        # We're building a PR
        echo "$(date --universal '+%Y-%m-%d')-$(git rev-parse --short HEAD)-pr_${PR}"
    else
        # otherwise it's the real thing
        echo "$(date --universal '+%Y-%m-%d')-$(git rev-parse --short HEAD)"
    fi
else
    # testing
    echo "$(date --universal '+%s')-$(git rev-parse --short HEAD)-test"
fi
