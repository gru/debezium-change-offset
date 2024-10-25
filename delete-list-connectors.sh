#!/bin/bash

# Список коннекторов для удаления
CONNECTORS_TO_DELETE="connector1,connector2,connector3"

# Перебор коннекторов из списка и их удаление
IFS=',' read -ra ADDR <<< "$CONNECTORS_TO_DELETE"
for connector in "${ADDR[@]}"; do
    echo "Удаляем коннектор: $connector"
    ./delete-connector.sh "$connector"
    if [ $? -eq 0 ]; then
        echo "Коннектор $connector успешно удален"
    else
        echo "Ошибка при удалении коннектора $connector"
    fi
done

echo "Все указанные коннекторы удалены"