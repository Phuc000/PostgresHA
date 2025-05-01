#!/bin/bash
set -e

# DON'T run initialization scripts manually
# The official PostgreSQL entrypoint handles this correctly

# Check if another primary exists in the cluster
check_other_primary() {
  # Try to connect to the replica node
  PGPASSWORD=1234567890 psql -h postgres-replica -p 5432 -U postgres -c "SELECT pg_is_in_recovery()" -t | grep 'f' > /dev/null 2>&1
  return $?
}

# If we're restarting after failure, and replica was promoted, start as replica
if [ -f "${PGDATA}/PG_VERSION" ]; then
  if check_other_primary; then
    echo "Detected another primary in the cluster. Starting as replica..."
    touch "${PGDATA}/standby.signal"
    cat > "${PGDATA}/postgresql.auto.conf" << EOF
primary_conninfo = 'host=postgres-replica port=5432 user=postgres password=1234567890'
promote_trigger_file = '/tmp/promote_me_to_master'
EOF
  else
    echo "No other primary detected. Starting as primary..."
    rm -f "${PGDATA}/standby.signal"
  fi
fi

# Let the official entrypoint handle everything else
echo "Starting PostgreSQL with official entrypoint..."
exec /usr/local/bin/docker-entrypoint.sh "$@"