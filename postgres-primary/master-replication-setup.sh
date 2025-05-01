#!/bin/bash
set -e
echo "Running master-replication-setup.sh script"

# Wait for PGDATA directory to exist
while [ ! -d "${PGDATA}" ]; do
  echo "Waiting for PGDATA directory to be created..."
  sleep 1
done

cat >> "${PGDATA}/pg_hba.conf" << EOF
host replication ${DB_REP_USER} 0.0.0.0/0 md5
EOF

cat >> "${PGDATA}/postgresql.conf" << EOF
wal_level = replica
wal_keep_size = 1GB
max_wal_senders = 10
hot_standby = on
EOF

# # Start postgres as the main process
# exec docker-entrypoint.sh postgres