#!/bin/bash
. config.sh

cd $WORKDIR/viz-world
# Переключаемся на ветку mainnet-dev (основная master)
git checkout mainnet-dev

# Качаем обновления
git fetch

# Переходим в свежее состояние
git pull

cd $WORKDIR/viz-world/build

cmake -DCMAKE_BUILD_TYPE=Release ..
cd $WORKDIR/viz-world/build/ && nohup make -j$(nproc) vizd > buildlog_vizd.txt
cd $WORKDIR/viz-world/build/ && nohup make -j$(nproc) cli_wallet > buildlog_cli_wallet.txt

exit 0
