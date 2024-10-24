#!/bin/bash

# Проверяем, передано ли имя коннектора
if [ -z "$1" ]; then
  echo "Пожалуйста, укажите имя коннектора."
  exit 1
fi

CONNECTOR_NAME=$1

# Отправляем запрос на получение статуса коннектора
curl -s -X GET http://localhost:8083/connectors/$CONNECTOR_NAME/status | jq
