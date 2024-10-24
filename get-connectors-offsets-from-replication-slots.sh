#!/bin/bash

# Имя контейнера PostgreSQL
POSTGRES_CONTAINER="debezium-change-offset-postgres-1"

# Команда для выполнения SQL-запроса
SQL_QUERY="
SELECT json_build_object(
    'connector', regexp_replace(slot_name, '_slot$', ''),
    'server', 'dbserver1',
    'txId', catalog_xmin,
    'lsn_commit', ('0x' || split_part(restart_lsn::text, '/', 2))::float,
    'lsn', ('0x' || split_part(confirmed_flush_lsn::text, '/', 2))::float
) AS result
FROM pg_replication_slots;"

# Выполнение SQL-запроса в контейнере и форматирование вывода
docker exec -it $POSTGRES_CONTAINER psql -U myuser -d mydb -t -c "$SQL_QUERY"

# Проверка кода возврата
if [ $? -ne 0 ]; then
    echo "Ошибка при выполнении запроса."
    exit 1
fi
