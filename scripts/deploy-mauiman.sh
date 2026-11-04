#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"
build_component mauiman https://invent.kde.org/maui/mauiman.git "${BRANCH_MAUIMAN:-master}" -DBUNDLE_MAUI_STYLE=ON
