source ./kafka-config.sh

curl -X POST -H "Content-Type: application/json" --data @outbox-connector.json $KAFKA_CONNECT_URL/connectors
