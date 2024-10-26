#!/bin/bash

source ./kafka-config.sh

# Получение списка всех коннекторов
connectors=$(curl -s -X GET "${KAFKA_CONNECT_URL}/connectors")

# Удаление квадратных скобок и кавычек из списка
connectors=$(echo $connectors | sed 's/\[//g' | sed 's/\]//g' | sed 's/"//g')

# Перебор всех коннекторов и их остановка
IFS=',' read -ra ADDR <<< "$connectors"
for connector in "${ADDR[@]}"; do
    echo "Останавливаем коннектор: $connector"
    curl -s -X PUT "${KAFKA_CONNECT_URL}/connectors/${connector}/pause"
    if [ $? -eq 0 ]; then
        echo "Коннектор $connector успешно остановлен"
    else
        echo "Ошибка при остановке коннектора $connector"
    fi
done

echo "Все коннекторы остановлены"
