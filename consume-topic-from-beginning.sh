#!/bin/bash

source ./kafka-config.sh

# Имя топика
TOPIC=$1

# Использование kafka-console-consumer.sh для чтения ключей сообщений и их обработки
$KAFKA_CONSOLE_CONSUMER --bootstrap-server $KAFKA_BROKER \
                        --topic $TOPIC \
                        --from-beginning \
                        --property print.key=true \
                        --property print.value=true \
                        --property key.separator=""
