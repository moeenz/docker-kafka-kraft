FROM openjdk:8u292-slim-buster

RUN apt-get update \
    && apt-get install -y wget

WORKDIR /opt/kafka

RUN wget https://apachemirror.wuchna.com/kafka/2.8.0/kafka_2.13-2.8.0.tgz
RUN tar xzvf kafka_2.13-2.8.0.tgz

WORKDIR /opt/kafka/kafka_2.13-2.8.0
COPY ./configs/server.properties /opt/kafka/kafka_2.13-2.8.0/config/kraft

COPY ./docker-entrypoint.sh /opt/kafka/kafka_2.13-2.8.0
COPY ./wait-for-it.sh /opt/kafka/kafka_2.13-2.8.0

ENV CONTAINER_HOST_NAME=
ENV CREATE_TOPICS=

EXPOSE 9092 9093

ENTRYPOINT [ "./docker-entrypoint.sh" ]
