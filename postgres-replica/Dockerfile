FROM postgres:14
RUN apt-get update && apt-get install -y vim && apt-get install -y netcat-traditional
COPY ./init-replica-server.sh /init-replica-server.sh
RUN chmod +x /init-replica-server.sh
ENTRYPOINT ["/init-replica-server.sh"]