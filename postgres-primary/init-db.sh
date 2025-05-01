#!/bin/bash
# debug line
echo "Running init-db.sh script"
set -e
psql -v ON_ERROR_STOP=1 --username "postgres" <<-EOSQL
EOSQL