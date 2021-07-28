FROM openjdk:8u292-slim-buster

WORKDIR /opt

ARG kafkaversion=2.8.0
ARG scalaversion=2.13

ENV KRAFT_CONTAINER_HOST_NAME=
ENV KRAFT_CREATE_TOPICS=
ENV KRAFT_PARTIONS_PER_TOPIC=

RUN apt update \
    && apt install -y --no-install-recommends wget

RUN wget https://mirrors.ocf.berkeley.edu/apache/kafka/${kafkaversion}/kafka_${scalaversion}-${kafkaversion}.tgz -O kafka.tgz \
    && tar xvzf kafka.tgz \
    && mv kafka_${scalaversion}-${kafkaversion} kafka

WORKDIR /opt/kafka

COPY ./configs/server.properties ./config/kraft
COPY ./*.sh .

EXPOSE 9092 9093

ENTRYPOINT [ "./docker-entrypoint.sh" ]
