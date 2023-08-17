#!/bin/bash
# Запуск cron в фоновом режиме с проверкой наличия процесса
# При запуске контейнера, если процесса нет, он будет запущен
# Команда для наблюдения за крон: crond -f -l 8
count=$(ps aux | grep -c crond)

if [ $count -eq 1 ]; then
    echo "Start crond"
    crond
fi
echo "Is running cron"

output=$(ps aux | grep crond)
echo "$output"
