#!/bin/bash

_term() {
    echo "🚨 Termination signal received...";
    kill -TERM "$child" 2>/dev/null
}

trap _term SIGINT SIGTERM

properties_file=/opt/kafka/config/kraft/server.properties;
kafka_addr=localhost:9093;

echo "==> Applying environment variables...";
echo "listeners=CONTROLLER://:19092,INTERNAL://:9092,EXTERNAL://:9093" >> $properties_file;
echo "advertised.listeners=INTERNAL://${KRAFT_CONTAINER_HOST_NAME}:9092,EXTERNAL://localhost:9093" >> $properties_file;
echo "inter.broker.listener.name=EXTERNAL" >> $properties_file;
echo "listener.security.protocol.map=CONTROLLER:PLAINTEXT,INTERNAL:PLAINTEXT,EXTERNAL:PLAINTEXT" >> $properties_file;
echo "==> ✅ Enivronment variables applied.";


echo "==> Setting up Kafka storage...";
export suuid=$(./bin/kafka-storage.sh random-uuid);
./bin/kafka-storage.sh format -t $suuid -c ./config/kraft/server.properties;
echo "==> ✅ Kafka storage setup.";


echo "==> Starting Kafka server...";
./bin/kafka-server-start.sh ./config/kraft/server.properties &
child=$!
echo "==> ✅ Kafka server started.";


if [ -z $KRAFT_CREATE_TOPICS ]; then
    echo "==> No topic requested for creation.";
else
    echo "==> Creating topics...";
    ./wait-for-it.sh $kafka_addr;
    for i in $(echo $KRAFT_CREATE_TOPICS | sed "s/,/ /g")
    do
        ./bin/kafka-topics.sh --create --topic "$i" --partitions 1 --replication-factor 1 --bootstrap-server $kafka_addr;
    done
    echo "==> ✅ Requested topics created.";
fi


wait "$child";
