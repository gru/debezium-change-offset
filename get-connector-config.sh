#!/bin/bash

source ./kafka-config.sh

# Проверка наличия аргумента с именем коннектора
if [ $# -eq 0 ]; then
    echo "Ошибка: Не указано имя коннектора."
    echo "Использование: $0 <имя_коннектора>"
    exit 1
fi

# Имя коннектора
CONNECTOR_NAME="$1"

# Получение конфигурации коннектора
echo "Получение конфигурации коннектора: $CONNECTOR_NAME"
RESPONSE=$(curl -s -X GET "${KAFKA_CONNECT_URL}/connectors/${CONNECTOR_NAME}/config")

# Проверка ответа
if [ $? -eq 0 ] && [ ! -z "$RESPONSE" ]; then
    echo "Конфигурация коннектора $CONNECTOR_NAME:"
    echo "$RESPONSE" | jq '.'
else
    echo "Ошибка при получении конфигурации коннектора $CONNECTOR_NAME"
    echo "Ответ сервера: $RESPONSE"
    exit 1
fi
