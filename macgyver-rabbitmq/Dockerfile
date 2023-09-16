FROM ghcr.io/unchartedsky/macgyver-java:latest

LABEL org.opencontainers.image.source = "https://github.com/unchartedsky/macgyver"

USER root

RUN mkdir -p /rabbitmq
WORKDIR /rabbitmq

RUN curl --silent -L -O https://github.com/rabbitmq/rabbitmq-perf-test/releases/download/v2.10.0/rabbitmq-perf-test-2.10.0-bin.tar.gz && \
    tar xvfz rabbitmq-perf-test-2.10.0-bin.tar.gz && \
    rm rabbitmq-perf-test-2.10.0-bin.tar.gz && \
    mv rabbitmq-perf-test-2.10.0 perf-test

USER app
