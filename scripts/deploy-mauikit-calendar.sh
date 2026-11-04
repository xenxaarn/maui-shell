#!/usr/bin/env bash

cd mauikit-calendar
cmake -DCMAKE_BUILD_TYPE="Release" \
  -DCMAKE_INSTALL_PREFIX="/usr" \
  -DBUNDLE_MAUI_STYLE=ON \
  .

make -j$(nproc)
DESTDIR=/ make install
make install
