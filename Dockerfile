#RabbitMQ version 3.4.3

FROM fedora:21

MAINTAINER Yury Kavaliou <Yury_Kavaliou@epam.com>

RUN rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc

ENV RMQ_VERSION 3.4.3
ENV RMQ_MINOR_VERSION 1

RUN yum install -y https://www.rabbitmq.com/releases/rabbitmq-server/v$RMQ_VERSION/rabbitmq-server-$RMQ_VERSION-$RMQ_MINOR_VERSION.noarch.rpm

RUN rabbitmq-plugins enable --offline rabbitmq_mqtt
RUN rabbitmq-plugins enable --offline rabbitmq_management

COPY /files/rabbit_start.sh /usr/local/sbin/rabbit_start.sh
COPY /files/rabbitmq.config /etc/rabbitmq/rabbitmq.config
COPY /files/.erlang.cookie /var/lib/rabbitmq/.erlang.cookie

RUN chown rabbitmq /var/lib/rabbitmq/.erlang.cookie
RUN chmod 700 /usr/local/sbin/rabbit_start.sh /var/lib/rabbitmq/.erlang.cookie

ENTRYPOINT ["/bin/bash", "/usr/local/sbin/rabbit_start.sh"]

VOLUME /var/log
VOLUME /var/run
VOLUME /var/lib/rabbitmq

# 5672 - RMQ AMQP port
# 15672 - RMQ Management HTTP
# 25672 - RMQ Clustering support 
# 4369 - RMQ Clustering support
# 1883 - RMQ MQTT non SSL
EXPOSE 5672 15672 25672 4369 1883
