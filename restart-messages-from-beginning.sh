#!/bin/bash

source ./kafka-config.sh

# Проверяем, что передан параметр INPUT_JSON
if [ -z "$1" ]; then
  echo "Ошибка: Необходимо передать параметр INPUT_JSON."
  exit 1
fi

# Парсим входной JSON
INPUT_JSON=$1
CONNECTOR=$(echo $INPUT_JSON | jq -r '.connector')
SERVER=$(echo $INPUT_JSON | jq -r '.server')

KEY="[\"$CONNECTOR\",{\"server\":\"$SERVER\"}]"

# Имя топика
TOPIC="connect_offsets"

# Отправка сообщения
echo "Отправка сообщения $KEY в топик $TOPIC..."
echo "$KEY|" | $KAFKA_CONSOLE_PRODUCER --bootstrap-server $KAFKA_BROKER \
                                       --topic $TOPIC \
                                       --property "parse.key=true" \
                                       --property "key.separator=|"

# Проверка кода возврата
if [ $? -eq 0 ]; then
    echo "Сообщение успешно отправлено."
else
    echo "Ошибка при отправке сообщения."
    exit 1
fi
