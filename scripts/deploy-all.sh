#!/usr/bin/env bash
set -euo pipefail
D="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
for s in mauiman mauikit mauicore cask-server maui-shell; do
  bash "$D/deploy-$s.sh"
done
echo "==> done. Run: cask -w"
