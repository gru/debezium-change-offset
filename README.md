## Проблема

При использовании Debezium для реализации паттерна outbox в PostgreSQL иногда возникает проблема несоответствия смещений. Это может произойти, например, при миграции базы данных PostgreSQL на другой сервер с помощью pg_dump. В результате, смещения в новой базе данных не соответствуют смещениям в топике connect-offsets, на который опирается Debezium при репликации данных. Скрипты в этом репозитории позволяют назначить новые смещения для развернутых коннекторов Debezium.

## Решение

Решение состоит из двух основных шагов:

1. Получение данных о текущих смещениях (confirmed_flush_lsn) из pg_replication_slots в мигрированной базе данных с помощью следующего SQL-запроса:

```sql
SELECT json_build_object(
    'connector', regexp_replace(slot_name, '_slot$', ''),
    'server', 'dbserver1',
    'txId', catalog_xmin,
    'lsn_commit', confirmed_flush_lsn::pg_lsn - '0/0'::pg_lsn
) AS result
FROM pg_replication_slots;
```

2. Отправка сообщения для каждого коннектора в топик connect-offsets в Kafka.

Сообщение имеет следующую структуру:
- Ключ:
```json
["outbox-connector",{"server":"dbserver1"}]
```
- Тело:
```json
{"transaction_id":null,"lsn_proc":24204776,"lsn_commit":24204776,"lsn":24204776,"txId":568,"ts_usec":1729958298105714}
```

После создания коннектора Debezium, он будет использовать новые смещения для чтения данных из базы данных.

## Применение

Для применения решения выполните следующие шаги:

1. Запустите SQL-запрос, приведенный выше, для получения данных о текущих смещениях в мигрированной базе данных.
2. Сохраните результат в файл connectors.data. Каждая строка файла должна содержать один JSON-объект, а последняя строка должна быть пустой.
3. Выполните скрипт restart-messages-from-lsn-from-file.sh, передав ему в качестве аргумента файл connectors.data:

```bash
./restart-messages-from-lsn-from-file.sh connectors.data
```

Это позволит обновить смещения для всех коннекторов, указанных в файле connectors.data, и обеспечит корректную работу Debezium с новой базой данных.

## Разработка

Остальные скрипты предназначены для разработки.