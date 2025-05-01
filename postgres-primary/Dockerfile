FROM postgres:14
RUN apt-get update && apt-get install -y vim netcat-traditional ssh

# Fix the directory name - this is where Postgres looks for initialization scripts
COPY init-db.sh /docker-entrypoint-initdb.d/
COPY master-replication-setup.sh /docker-entrypoint-initdb.d/

# Make scripts executable
RUN chmod +x /docker-entrypoint-initdb.d/init-db.sh \
    && chmod +x /docker-entrypoint-initdb.d/master-replication-setup.sh

# Do NOT override the ENTRYPOINT - remove these lines entirely
# ENTRYPOINT ["/master-replication-setup.sh", "/init-db.sh"]