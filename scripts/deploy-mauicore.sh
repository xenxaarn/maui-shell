#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"
build_component maui-core https://github.com/xenxaarn/maui-core.git "${BRANCH_MAUICORE:-main}"
