#!/bin/bash
. config.sh

apt-get update && apt-get install -y build-essential autoconf automake cmake g++ git libssl-dev libtool make pkg-config python3 python3-jinja2 libboost-chrono-dev libboost-context-dev libboost-coroutine-dev libboost-date-time-dev libboost-filesystem-dev libboost-iostreams-dev libboost-locale-dev libboost-program-options-dev libboost-serialization-dev libboost-signals-dev libboost-system-dev libboost-test-dev libboost-thread-dev doxygen libncurses5-dev libreadline-dev perl

fallocate -l 10G $WORKDIR_SWAP/swapfile
ls -lh $WORKDIR_SWAP/swapfile
chmod 600 $WORKDIR_SWAP/swapfile
mkswap $WORKDIR_SWAP/swapfile
swapon $WORKDIR_SWAP/swapfile
swapon --show

mount -o remount,size=10G /dev/shm
mount -l | grep "/dev/shm"

free -h
echo '$WORKDIR_SWAP/swapfile none swap sw 0 0' | tee -a /etc/fstab
cat /etc/fstab

sysctl vm.swappiness=80
sysctl vm.vfs_cache_pressure=50
echo "vm.swappiness=80" >> /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf
tail /etc/sysctl.conf

# Настройка часового пояса, производится вводом цифры региона и местоположения.
# Перезапустить настройку можно командой sudo dpkg-reconfigure tzdata.
apt-get install -y screen tzdata

cd $WORKDIR
git clone https://github.com/VIZ-World/viz-world.git
cd $WORKDIR/viz-world
#git checkout master
git checkout mainnet-dev
#git checkout mainnet-test2
git submodule update --init --recursive -f

mkdir $WORKDIR/viz-world/build
cd $WORKDIR/viz-world/build

cmake -DCMAKE_BUILD_TYPE=Release ..
cd $WORKDIR/viz-world/build/ && nohup make -j$(nproc) vizd > buildlog_vizd.txt
cd $WORKDIR/viz-world/build/ && nohup make -j$(nproc) cli_wallet > buildlog_cli_wallet.txt

# cd $WORKDIR/viz-world/build/programs/vizd/ && rm -f screenlog.0 && screen -dmLS vizd $WORKDIR/viz-world/build/programs/vizd/vizd --resync
# sleep 5s
# screen -S vizd -p 0 -X quit

# Копируем снапшот в каталог к исполняемому файлу
mkdir $WORKDIR/viz-world/build/programs/vizd/witness_node_data_dir
cp $WORKDIR/viz-world/share/vizd/snapshot.json $WORKDIR/viz-world/build/programs/vizd/witness_node_data_dir

# Заполняем параметрами конфиг ноды.
cat <<EOT > $WORKDIR/viz-world/build/programs/vizd/witness_node_data_dir/config.ini
shared-file-dir = "blockchain"
shared-file-size = 2G
inc-shared-file-size = 2G
min-free-shared-file-size = 500M
block-num-check-free-size = 1000
single-write-thread = 0
clear-votes-before-block = 0
skip-virtual-ops = 0
enable-plugins-on-push-transaction = 0
follow-max-feed-size = 500
webserver-thread-pool-size = 256

# minimal plugins
plugin = chain p2p json_rpc webserver network_broadcast_api

p2p-seed-node = 172.104.132.57:9099
p2p-seed-node = 94.16.120.147:4248
p2p-seed-node = 142.93.228.7:2001
p2p-seed-node = 178.62.61.190:8099
p2p-seed-node = 13.81.61.249:2001
p2p-seed-node = 54.93.168.9:2001

p2p-endpoint = 0.0.0.0:8082

enable-stale-production = true
required-participation = 0

[log.console_appender.stderr]
stream = std_error

[log.file_appender.p2p]
filename = logs/p2p/p2p.log

[logger.default]
level = all
appenders = stderr

[logger.p2p]
level = all
appenders = p2p
EOT

# Запускаем ноду в сесии screen
# 
#cd $WORKDIR/viz-world/build/programs/vizd/ && rm -f screenlog.0 && screen -dmLS vizd $WORKDIR/viz-world/build/programs/vizd/vizd --resync

exit 0
