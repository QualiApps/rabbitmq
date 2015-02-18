#!/bin/bash

CLUSTER_WITH=""
CLUSTERED=""
RAM_NODE=""

while getopts ":m:c:r:" option; do
  case "$option" in
    m)
      CLUSTER_WITH=${OPTARG} ;;
    c)
      CLUSTERED=1 ;;
    r)
      RAM_NODE="--ram" ;;
    \?)
      echo "
Usage: [options]
  Options:

   -m        master node IP
   -c        enable clustered mode
   -r        node type switch, RAM node if used, otherwise DISC node
   " >&2
      exit 1
      ;;
  esac
done

if [ -z "$CLUSTERED" ]; then
        # if not clustered then start it normally as if it is a single server
        /usr/sbin/rabbitmq-server
else
        if [ -z "$CLUSTER_WITH" ]; then
                # if clustered mode enabled, but CLUSTER_WITH is not specified then again start normally,
                # could be the first server in the cluster
                /usr/sbin/rabbitmq-server
        else
                /usr/sbin/rabbitmq-server -detached

                rabbitmqctl stop_app
                rabbitmqctl join_cluster $RAM_NODE rabbit@$CLUSTER_WITH
                rabbitmqctl start_app

                #rabbitmqctl set_policy ha-all "" '{"ha-mode":"all","ha-sync-mode":"automatic"}'
                rabbitmqctl set_policy ha-two "" '{"ha-mode":"exactly","ha-params":2,"ha-sync-mode":"automatic"}'
                
                # tail to keep the a foreground process active.
                tail -f /var/log/rabbitmq/rabbit\@$HOSTNAME.log
        fi
fi

exec "$@"
