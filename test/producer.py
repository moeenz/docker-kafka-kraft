from kafka import KafkaProducer

producer = KafkaProducer(bootstrap_servers="localhost:9093")
for _ in range(3):
    producer.send("topic-a", b"test message")
