#!/bin/bash
set -e

CONTAINER_NAME="enterprise_mlops_app"

echo "Attempting to find container named $CONTAINER_NAME..."

# Check if a container with the specified name is running
RUNNING_CONTAINER=$(docker ps -q -f name=$CONTAINER_NAME)

if [ -n "$RUNNING_CONTAINER" ]; then
    echo "Found container $CONTAINER_NAME (ID: $RUNNING_CONTAINER). Stopping..."
    # Stop the container with a timeout (e.g., 30 seconds)
    docker stop -t 30 $CONTAINER_NAME || { echo "Warning: Failed to stop container"; }
    echo "Removing container $CONTAINER_NAME..."
    docker rm -f $CONTAINER_NAME || { echo "Warning: Failed to remove container"; }
else
    echo "No running container named $CONTAINER_NAME found."
fi

echo "stop_server.sh completed."
