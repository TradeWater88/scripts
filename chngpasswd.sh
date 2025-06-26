#!/bin/bash

PORT="8661"

# Функция для изменения пароля пользователя
change_password() {
    local username="$1"
    local new_password="$2"

    mysql  -P "$PORT" -e "SET PASSWORD FOR '$username'@'%' = '$new_password';"
}

# Меню выбора опций
echo "1. Change user password"
echo "2. Exit"

read -p "Enter your option: " option

error="Use 1 for password change"

case $option in
    1)
        read -p "Enter username: " username
        read -p "Enter new password: " new_password

        # Изменение пароля
        change_password "$username" "$new_password"
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
