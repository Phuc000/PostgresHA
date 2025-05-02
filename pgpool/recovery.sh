#!/bin/bash
# Recovery script for PgPool
# Parameters passed by PgPool:
# $1: new primary data directory
# $2: hostname of the server to be recovered
# $3: data directory of the server to be recovered
# $4: port number of the recovered server

echo "Starting recovery for $2" >> /var/log/postgresql/recovery.log
date >> /var/log/postgresql/recovery.log

# Configure the node to start in standby mode
docker exec $2 touch /tmp/rejoin_as_replica

echo "Recovery completed" >> /var/log/postgresql/recovery.log
exit 0