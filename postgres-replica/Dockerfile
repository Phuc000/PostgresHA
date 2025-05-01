FROM postgres:14

# Install required packages efficiently
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    vim \
    netcat-traditional && \
    rm -rf /var/lib/apt/lists/*

# Place initialization script in standard directory
COPY ./init-replica-server.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/init-replica-server.sh

# Do not override ENTRYPOINT - use the default PostgreSQL entrypoint