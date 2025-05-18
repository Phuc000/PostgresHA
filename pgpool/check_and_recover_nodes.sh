#!/bin/bash
# filepath: /usr/local/bin/check_and_recover_nodes.sh
# Check for down nodes
PGPASSWORD=1234567890 psql -h localhost -p 9999 -U postgres -t -c "SHOW POOL_NODES" | while read line; do
  if [[ $line == *"down"* ]]; then
    node_id=$(echo $line | awk '{print $1}')
    echo "Node $node_id is down, attempting recovery..."
    # Correct syntax for pcp_recovery_node - password must be after -w without space
    pcp_recovery_node -h localhost -p 9898 -U postgres -w -n $node_id
  fi
done