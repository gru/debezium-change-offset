#!/bin/bash

# Проверяем, передано ли имя коннектора
if [ $# -eq 0 ]; then
    echo "Ошибка: Не указано имя коннектора."
    echo "Использование: $0 <имя_коннектора>"
    exit 1
fi

# Имя коннектора
CONNECTOR_NAME="$1"

# Адрес Kafka Connect REST API
CONNECT_URL="http://localhost:8083"

# Отправляем DELETE запрос для удаления коннектора
echo "Удаляем коннектор $CONNECTOR_NAME..."
RESPONSE=$(curl -s -X DELETE "$CONNECT_URL/connectors/$CONNECTOR_NAME")

if [ -z "$RESPONSE" ]; then
    echo "Коннектор удален"
else
    echo "Произошла ошибка: $RESPONSE"
fi