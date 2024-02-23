from kafka import TopicPartition
from kafka import KafkaConsumer

consumer = KafkaConsumer(bootstrap_servers="localhost:9093")
consumer.assign([TopicPartition("topic-a", 3)])
for msg in consumer:
    print(msg.value)
