Installation
--------------

1. Install [Docker](https://www.docker.com)

2. Download automated build from public Docker Hub Registry: `docker pull qapps/rabbitmq`
(alternatively, you can build an image from Dockerfile: `docker build -t="qapps/rabbitmq" github.com/qualiapps/rabbitmq`)

Start RabbitMQ broker as a daemon
--------------

`docker run -d -p 15672:15672 -p 1883:1883 -p 5672:5672 -h rabbitmq --name rabbitmq qapps/rabbitmq`
