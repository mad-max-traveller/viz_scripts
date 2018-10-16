#!/bin/bash
. config.sh
# Error parsing command line: option '--replay' is ambiguous and matches '--replay-blockchain', and '--replay-if-corrupted'
#cd $WORKDIR/viz-world/build/programs/vizd/ && rm -f screenlog.0 && screen -dmLS vizd $WORKDIR/viz-world/build/programs/vizd/vizd --replay
#cd $WORKDIR/viz-world/build/programs/vizd/ && rm -f screenlog.0 && screen -dmLS vizd $WORKDIR/viz-world/build/programs/vizd/vizd --replay-if-corrupted
cd $WORKDIR/viz-world/build/programs/vizd/ && rm -f screenlog.0 && screen -dmLS vizd $WORKDIR/viz-world/build/programs/vizd/vizd --replay-blockchain

echo "Подключиться к запущенной сессии: screen -x vizd"
echo "Отключиться с сохранением сессии: Ctr+A+D"

exit 0
