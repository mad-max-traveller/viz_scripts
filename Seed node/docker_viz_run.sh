#!/bin/bash

# Перед запуском контейнера положите скрипты в монтируемую папку.
# Локальный каталог монтируемый в контейнер /mnt/files/viz 
# КУда монтируется локальный каталог внутри нашего контейнера /viz

echo "Запуск контейнера:"

docker run -i -t -v /mnt/files/viz:/viz --rm 1and1internet/ubuntu-16 bash

echo "Подключиться к запущенному контейнеру:"
echo "docker exec -i -t id bash"
echo "Выход по Ctrl+D"
echo "Чтобы отсоединить TTY (отключиться от контейнера) без остановки контейнера нажмите Ctr+P + Ctrl+Q"

echo "После настройки ноды рекомендуется сохранить все изменения с помощью комманды:"
echo "docker commit id new_image_name"
echo "И после этого запускать контейнер следующей командой:"
echo "docker run -i -t -v /mnt/files/viz:/viz new_image_name-16 bash"

exit 0
