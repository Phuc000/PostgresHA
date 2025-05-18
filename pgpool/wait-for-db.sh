#!/bin/bash
# This line is to tell the interpreter to error out and quit further execution if any step fails
set -e

echo "Performing EXTREME PgPool cleanup..."

# Kill any running pgpool processes more aggressively
pkill -9 pgpool || true
sleep 1

# Use find to locate and remove any PID files
find / -name "pgpool.pid" -delete 2>/dev/null || true
find / -name "*.socket" -delete 2>/dev/null || true
find /tmp -name ".s.PGSQL*" -delete 2>/dev/null || true
find /var/run -name ".s.PGSQL*" -delete 2>/dev/null || true

# Remove known locations explicitly
rm -rf /var/run/pgpool
rm -rf /tmp/.s.PGSQL*
rm -rf /var/run/postgresql/.s.PGSQL*
rm -f /etc/pgpool2/pgpool.pid

# Recreate with proper permissions
mkdir -p /var/run/pgpool
mkdir -p /var/log/postgresql
chmod -R 777 /var/run/pgpool

echo "Extreme cleanup completed"

check_retry_count () {
  RETRY_COUNT=$1
  MAX_RETRY=10
  failed_db_host=$2
  if [ $RETRY_COUNT -eq $MAX_RETRY ]; then
     echo "Maximum retry for checking DB($failed_db_host) to be online is reached, exiting..."
     exit 3
  fi
}
db_host_names=(postgres-primary postgres-replica)
for str in ${db_host_names[*]}; do
  RETRY_COUNT=0
  until nc -z $str 5432; do
    check_retry_count $RETRY_COUNT $str
    ((RETRY_COUNT=RETRY_COUNT+1))
    
    echo "$(date) - waiting for $str to be online..."
    sleep 3s
  done
  echo "** $str host is online, trying remaining hosts ***"
done
echo "* All the required DB hosts are online *"

# Start pgpool in foreground mode
echo "Starting PgPool-II in foreground mode..."
/usr/local/bin/monitor_nodes.sh &
exec pgpool -n