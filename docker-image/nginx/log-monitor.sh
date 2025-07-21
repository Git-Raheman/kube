#!/bin/sh
set -e

LOG_DIR="/logs"
ACCESS_LOG="$LOG_DIR/access.log"
ERROR_LOG="$LOG_DIR/error.log"

# Wait for NGINX to start
sleep 5

# Check logs every 5 seconds
while true; do
  if [ ! -f "$ACCESS_LOG" ] || [ ! -f "$ERROR_LOG" ]; then
    echo "Logs missing. Recreating..."
    touch "$ACCESS_LOG" "$ERROR_LOG"
    chown nginx:nginx "$ACCESS_LOG" "$ERROR_LOG"
    nginx -s reopen 2>/dev/null || true  # Skip errors
  fi
  sleep 5
done
