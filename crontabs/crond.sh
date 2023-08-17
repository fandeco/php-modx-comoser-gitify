#!/bin/bash


# Путь к папке, которую нужно отслеживать
folder="/var/www/html/core/scheduler/crontabs"

# Получаем владельца папки и пользователя, для которого будут создаваться задания
#user=$(stat -c '%U' "$folder")
user='www-data'

if [ -e "$folder" ]; then
    echo "Создаем crontab для $user"
else
    echo "Папка $folder не существует"
    exit 1
fi

# Путь к файлу, с которым нужно сравнивать
target_file="/var/spool/cron/crontabs/$user"

# Проверяем наличие файла dockerrun в папке
if [ -f "$folder/$user" ]; then
    # Проверяем наличие целевого файла
    if [ ! -f "$target_file" ]; then
        # Если целевой файл не существует, выполняем команду crontab для создания нового
        crontab -u "$user" "$folder/$user"
        #echo "Файл $target_file создан"
    else
        # Сравниваем содержимое файлов
        diff_result=$(diff "$folder/$user" "$target_file")
        if [ "$diff_result" != "" ]; then
            # Если есть изменения, выполняем команду crontab для обновления файла
            crontab -u "$user" "$folder/$user"
            #echo "Файл $target_file обновлен"
        #else
            #echo "Файлы $folder/$user и $target_file идентичны"
        fi
    fi
else
    echo "Файл $folder/$user не найден"
fi
