#!/bin/bash

# Функция для вывода логов
log() {
    echo "$1" | tee -a script.log
}

# Функция для запроса пути у пользователя
ask_for_directory() {
    read -p "Введите путь до корневого каталога создания директорий: " directory
}

# Обработка опций
while getopts "d:" opt; do
    case $opt in
        d)
            directory=$OPTARG
            ;;
        *)
            echo "Использование: $0 [-d directory]"
            exit 1
            ;;
    esac
done

# Если путь не задан, запросить у пользователя
if [ -z "$directory" ]; then
    ask_for_directory
fi

# Проверка, существует ли директория
if [ ! -d "$directory" ]; then
    mkdir "$directory"
fi

# Получение списка всех пользователей из /etc/passwd
users=$(cut -d: -f1 /etc/passwd)

# Создание директорий для каждого пользователя
for user in $users; do
    user_home="$directory/$user"
    
    if [ ! -d "$user_home" ]; then
        mkdir -p "$user_home"
        chown "$user":"$user" "$user_home"
        chmod 755 "$user_home"
        log "Директория $user_home создана и установлены права 755."
    else
        log "Директория $user_home уже существует."
    fi
done

log "Скрипт выполнен успешно."
