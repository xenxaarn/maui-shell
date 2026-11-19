#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE}")/_common.sh"
build_component mauiman https://kde.org "${BRANCH_MAUIMAN:-master}" -DBUNDLE_MAUI_STYLE=ON
