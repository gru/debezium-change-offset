# Загружаем конфигурацию Kafka
source ./kafka-config.sh

# Читаем файл построчно
while IFS= read -r line; do

    # Пропускаем пустые строки
    if [ -z "$line" ]; then
        continue
    fi

    # Извлекаем имя коннектора из строки
    CONNECTOR_NAME=$(echo $line | jq -r '.connector')

    echo "Получение конфигурации коннектора: $CONNECTOR_NAME"
    # Запрашиваем конфигурацию коннектора
    CONFIG=$(curl -s -X GET "${KAFKA_CONNECT_URL}/connectors/${CONNECTOR_NAME}/config")

    # Проверяем, существует ли коннектор
    if echo "$CONFIG" | jq -e '.error_code == 404' > /dev/null; then
        echo "Коннектор $CONNECTOR_NAME не найден. Пропускаем удаление."

        # Перезапускаем сообщения с определенного LSN
        ./restart-messages-from-lsn.sh "$line"
    else
        # Форматируем конфигурацию коннектора
        CONFIG=$(echo $CONFIG | jq -c '{
            "name": "'$CONNECTOR_NAME'",
            "config": .
        }')
        # Маскируем конфиденциальные данные в конфигурации
        MASKED_CONFIG=$(echo $CONFIG | jq '.config | with_entries(if .key | startswith("database.") then .value = "***********" else . end)')
        echo "Конфигурация коннектора $CONNECTOR_NAME: $MASKED_CONFIG"

        # Удаляем существующий коннектор
        echo "Удаляем коннектор $CONNECTOR_NAME..."
        DELETE_RESPONSE=$(curl -s -X DELETE "$KAFKA_CONNECT_URL/connectors/$CONNECTOR_NAME")
        echo "Удален коннектор $CONNECTOR_NAME"

        # Перезапускаем сообщения с определенного LSN
        ./restart-messages-from-lsn.sh "$line"

        # Создаем коннектор заново
        echo "Создаем коннектор $CONNECTOR_NAME..."
        CREATE_RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" --data "$CONFIG" $KAFKA_CONNECT_URL/connectors)
        # Маскируем конфиденциальные данные в ответе
        MASKED_CREATE_RESPONSE=$(echo $CREATE_RESPONSE | jq '.config | with_entries(if .key | startswith("database.") then .value = "***********" else . end)')
        echo "Создан коннектор $CONNECTOR_NAME, ответ сервера: $MASKED_CREATE_RESPONSE"
    fi

done < $1
