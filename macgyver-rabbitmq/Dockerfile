FROM openjdk

# Set the timezone to KST
RUN cat /usr/share/zoneinfo/Asia/Seoul > /etc/localtime

RUN mkdir -p /rabbitmq

WORKDIR /rabbitmq

RUN curl -L -O https://github.com/rabbitmq/rabbitmq-perf-test/releases/download/v2.10.0/rabbitmq-perf-test-2.10.0-bin.tar.gz && \
    tar xvfz rabbitmq-perf-test-2.10.0-bin.tar.gz && \
    rm rabbitmq-perf-test-2.10.0-bin.tar.gz && \
    mv rabbitmq-perf-test-2.10.0 perf-test
