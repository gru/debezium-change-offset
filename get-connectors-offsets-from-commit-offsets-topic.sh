#!/bin/bash

source ./kafka-config.sh

# Имя топика
TOPIC="connect_offsets"

# Использование kafka-console-consumer.sh для чтения ключей сообщений и их обработки
$KAFKA_CONSOLE_CONSUMER --bootstrap-server $KAFKA_BROKER \
                        --topic $TOPIC \
                        --from-beginning \
                        --property print.key=true \
                        --property print.value=true \
                        --property key.separator="," \
                        --timeout-ms 5000 | \
while read -r line; do
    if echo "$line" | grep -q "transaction_id"; then
        echo "[$line]" | jq -r -c '{
            "connector": .[0][0],
            "server": .[0][1].server,
            "txId": .[1].txId,
            "lsn": .[1].lsn,
            "lsn_commit": .[1].lsn_commit,
            "ts_usec": .[1].ts_usec
        }'
    fi
done
