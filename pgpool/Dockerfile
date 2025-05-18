FROM ubuntu:20.04
RUN apt-get update && apt-get install -y pgpool2 && apt-get install -y vim && apt-get install -y postgresql-client && apt-get install -y netcat-traditional
COPY wait-for-db.sh /wait-for-db.sh
COPY recovery.sh /recovery.sh
RUN chmod +x /recovery.sh
COPY check_and_recover_nodes.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/check_and_recover_nodes.sh
COPY monitor_nodes.sh /usr/local/bin/
COPY ./.pcppass /root/.pcppass
RUN chmod 600 /root/.pcppass
RUN chmod +x /usr/local/bin/monitor_nodes.sh
RUN chmod +x /wait-for-db.sh
ENTRYPOINT ["/wait-for-db.sh"]
