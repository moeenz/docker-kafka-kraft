FROM eclipse-temurin:8u402-b06-jre-alpine

WORKDIR /opt

ARG kafkaversion=3.6.1
ARG scalaversion=2.13

ENV KRAFT_CONTAINER_HOST_NAME=
ENV KRAFT_CREATE_TOPICS=
ENV KRAFT_PARTITIONS_PER_TOPIC=

RUN apk --no-cache add curl bash

RUN curl -o kafka.tgz https://mirrors.ocf.berkeley.edu/apache/kafka/${kafkaversion}/kafka_${scalaversion}-${kafkaversion}.tgz \
    && tar xvzf kafka.tgz \
    && mv kafka_${scalaversion}-${kafkaversion} kafka

WORKDIR /opt/kafka

COPY ./configs/server.properties ./config/kraft
COPY ./*.sh .

EXPOSE 9092 9093

ENTRYPOINT [ "./docker-entrypoint.sh" ]
