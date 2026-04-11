#!/usr/bin/env bash

set -e

COMMAND=""
ENV="default"
OUTPUT="table"
CONFIG="config/servers.ini"

# Parse flags
while [[ "$#" -gt 0 ]]; do
  case $1 in
    inventory|health-check|backup)
      COMMAND="$1"
      ;;
    --env)
      ENV="$2"
      shift
      ;;
    --output)
      OUTPUT="$2"
      shift
      ;;
    --config)
      CONFIG="$2"
      shift
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

echo "[INFO] Command: $COMMAND"
echo "[INFO] Environment: $ENV"
echo "[INFO] Output format: $OUTPUT"
echo "[INFO] Config file: $CONFIG"

case "$COMMAND" in
  inventory)
    ./scripts/inventory/server-inventory.sh "$ENV" "$OUTPUT"
    ;;
  health-check)
    ./scripts/health-check/health-check.sh "$ENV"
    ;;
  backup)
    ./scripts/backup/backup.sh "$ENV"
    ;;
  *)
    echo "Usage: $0 {inventory|health-check|backup} [--env dev|prod] [--output json|csv]"
    exit 1
    ;;
esac
