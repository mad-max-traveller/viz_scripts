#!/bin/bash
. config.sh

cd $WORKDIR/viz-world/build/programs/vizd/ && rm -f screenlog.0 && screen -dmLS vizd $WORKDIR/viz-world/build/programs/vizd/vizd --resync-blockchain

echo "Подключиться к запущенной сессии: screen -x vizd"
echo "Отключиться с сохранением сессии: Ctr+A+D"

exit 0
