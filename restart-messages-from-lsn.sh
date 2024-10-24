#!/bin/bash

source ./kafka-config.sh

# Проверяем, что передан параметр JSON
if [ -z "$1" ]; then
  echo "Ошибка: Необходимо передать JSON строку."
  exit 1
fi

# Получаем текущие микросекунды Unix эпохи
CURRENT_TS_USEC=$(($(date +%s%N)/1000))

# Парсим входной JSON
INPUT_JSON=$1
CONNECTOR=$(echo $INPUT_JSON | jq -r '.connector')
SERVER=$(echo $INPUT_JSON | jq -r '.server')
TXID=$(echo $INPUT_JSON | jq -r '.txId')
LSN_COMMIT=$(echo $INPUT_JSON | jq -r '.lsn_commit')
LSN=$(echo $INPUT_JSON | jq -r '.lsn')

# Формируем KEY и VALUE
KEY="[\"$CONNECTOR\",{\"server\":\"$SERVER\"}]"
VALUE="{\"transaction_id\":null,\"lsn_proc\":$LSN,\"lsn_commit\":$LSN_COMMIT,\"lsn\":$LSN,\"txId\":$TXID,\"ts_usec\":$CURRENT_TS_USEC}"

# Имя топика
TOPIC="connect_offsets"

# Отправка сообщения
echo "Отправка сообщения в топик $TOPIC..."
echo "$KEY|$VALUE" | $KAFKA_CONSOLE_PRODUCER --bootstrap-server $KAFKA_BROKER \
                                             --topic $TOPIC \
                                             --property "parse.key=true" \
                                             --property "key.separator=|"

# Проверка кода возврата
if [ $? -eq 0 ]; then
    echo "Сообщение успешно отправлено."
    echo "Ключ: $KEY"
    echo "Значение: $VALUE"
else
    echo "Ошибка при отправке сообщения."
    exit 1
fi
