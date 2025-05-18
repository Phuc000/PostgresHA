#!/bin/bash
# filepath: d:\Github_repo\HAProxy\haproxy-db-failover\pgpool\monitor_nodes.sh
echo "Starting PgPool node monitor..."

while true; do
  # Check if PgPool is accepting connections
  if ! PGPASSWORD=1234567890 psql -h localhost -p 9999 -U postgres -c "SELECT 1" &>/dev/null; then
    echo "PgPool is not accepting connections. Checking nodes..."
    
    # Try to connect directly to PostgreSQL
    if pg_isready -h postgres-primary -p 5432 -t 3 &>/dev/null; then
      echo "Primary server is available but PgPool doesn't recognize it. Recovering..."
      pcp_recovery_node -h localhost -p 9898 -w -U postgres -n 0
    fi
    
    if pg_isready -h postgres-replica -p 5432 -t 3 &>/dev/null; then
      echo "Replica server is available but PgPool doesn't recognize it. Recovering..."
      pcp_recovery_node -h localhost -p 9898 -w -U postgres -n 1
    fi
  else
    echo "PgPool is working correctly. Running normal node check..."
    /usr/local/bin/check_and_recover_nodes.sh
  fi
  sleep 10
done