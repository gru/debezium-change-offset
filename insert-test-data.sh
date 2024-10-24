#!/bin/bash

# Параметры подключения к базе данных
DB_NAME="mydb"
DB_USER="myuser"
DB_PASSWORD="mypassword" 
CONTAINER_NAME="debezium-change-offset-postgres-1"  # Имя контейнера PostgreSQL

# Путь к SQL-файлу внутри контейнера
SQL_FILE="/tmp/insert_test_data.sql"

# Выполнение SQL-скрипта внутри контейнера
docker exec -i ${CONTAINER_NAME} psql -U $DB_USER -d $DB_NAME -f $SQL_FILE

# Проверка статуса выполнения
if [ $? -eq 0 ]; then
    echo "Тестовые данные успешно добавлены в таблицу outbox."
else
    echo "Произошла ошибка при добавлении тестовых данных."
fi
