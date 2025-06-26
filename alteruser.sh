#!/bin/bash

PORT="8661"

# Функция для блокировки/разблокировки пользователя
alter_user() {
    local username="$1"
    local action="$2"

    # Выполняем команду mysql и проверяем код возврата
    if ! mysql -P "$PORT" -e "ALTER USER '$username'@'%' account $action;" ; then
        echo "Failed to execute mysql command"
        exit 1
    fi

    # Если предыдущая команда выполнена успешно, выполняем следующую
    if ! mysql -P "$PORT" -e "flush privileges;" ; then
        echo "Failed to execute mysql command"
        exit 1
    fi


}

# Меню выбора опций
echo "1. Alter user"
echo "2. Exit"

read -p "Enter your option: " option

error="Use 1 for alter user"

case $option in
    1)
        read -p "Enter username: " username
        read -p "Enter action: " action

        # Изменение прав доступа
        alter_user "$username" "$action"
        echo "Done! ;)"
        exit 0
        ;;
    2)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid option"
        exit 1
        ;;
esac
