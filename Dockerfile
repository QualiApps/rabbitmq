# Version: 0.0.1

FROM fedora:21

MAINTAINER Yury Kavaliou <test@test.com>

RUN rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
RUN yum install -y https://www.rabbitmq.com/releases/rabbitmq-server/v3.4.3/rabbitmq-server-3.4.3-1.noarch.rpm

RUN rabbitmq-plugins enable --offline rabbitmq_mqtt
RUN rabbitmq-plugins enable --offline rabbitmq_management

ADD /files/startrmq.sh /usr/local/sbin/startrmq.sh
ADD /files/rabbitmq.config /etc/rabbitmq/rabbitmq.config
ADD /files/.erlang.cookie /var/lib/rabbitmq/.erlang.cookie

RUN chown rabbitmq /var/lib/rabbitmq/.erlang.cookie
RUN chmod 700 /usr/local/sbin/startrmq.sh /var/lib/rabbitmq/.erlang.cookie

ENTRYPOINT ["/bin/bash", "/usr/local/sbin/startrmq.sh"]
CMD [""]

EXPOSE 5672 15672 25672 4369 1883
