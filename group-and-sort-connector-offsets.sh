#!/bin/bash

# Проверка на существование файла
if [ ! -f "$1" ]; then
    echo "Файл $1 не существует."
    exit 1
fi

# Группировка, сортировка и вывод строки с максимальным ts_usec для каждого connector
jq -s 'group_by(.connector) | map(max_by(.ts_usec))' "$1"
