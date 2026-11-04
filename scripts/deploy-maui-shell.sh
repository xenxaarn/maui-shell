#!/usr/bin/env bash

MAUIKIT_VERSION=$([ -z $BRANCH_MAUIKIT ] && echo "master" || echo $BRANCH_MAUIKIT)

echo "Cloning from branch $MAUIKIT_VERSION"

git clone https://github.com/xenxaarn/maui-shell.git --depth=1 -b $MAUIKIT_VERSION

mkdir -p maui-shell && cd maui-shell
cmake -DCMAKE_BUILD_TYPE="Release" \
  -DCMAKE_INSTALL_PREFIX="/usr" \
  ../../

make -j$(nproc)
make install
