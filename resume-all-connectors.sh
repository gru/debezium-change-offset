#!/bin/bash

# Конфигурация
KAFKA_CONNECT_URL="http://localhost:8083"  # Замените на фактический URL вашего Kafka Connect

# Получение списка всех коннекторов
connectors=$(curl -s -X GET "${KAFKA_CONNECT_URL}/connectors")

# Удаление квадратных скобок и кавычек из списка
connectors=$(echo $connectors | sed 's/\[//g' | sed 's/\]//g' | sed 's/"//g')

# Перебор всех коннекторов и их запуск
IFS=',' read -ra ADDR <<< "$connectors"
for connector in "${ADDR[@]}"; do
    echo "Запускаем коннектор: $connector"
    curl -s -X PUT "${KAFKA_CONNECT_URL}/connectors/${connector}/resume"
    if [ $? -eq 0 ]; then
        echo "Коннектор $connector успешно запущен"
    else
        echo "Ошибка при запуске коннектора $connector"
    fi
done

echo "Все коннекторы запущены"