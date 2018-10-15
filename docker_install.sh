#!/bin/bash

echo "Обновляем пакетную базу"
apt update && apt -y install apt-transport-https ca-certificates curl software-properties-common

echo "Добавляем репозиторий Docker-а"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

echo "Устанавливаем Docker"
apt update && apt install -y docker-ce

exit 0
