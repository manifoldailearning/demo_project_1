#!/bin/bash
set -e

# Function for logging with timestamps.
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Configuration (override these via environment variables if needed)
AWS_REGION="${AWS_REGION:-us-east-1}"
ACCOUNT_ID="${ACCOUNT_ID:-866824485776}"
REPOSITORY_NAME="${REPOSITORY_NAME:-enterprise-mlops-app}"
IMAGE_TAG="${IMAGE_TAG:-latest}"
CONTAINER_NAME="${CONTAINER_NAME:-enterprise_mlops_app}"
ECR_REPO_URI="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPOSITORY_NAME}:${IMAGE_TAG}"

# Log in to Amazon ECR.
log "Logging in to ECR..."
aws ecr get-login-password --region "${AWS_REGION}" | \
  docker login --username AWS --password-stdin "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

# Pull the latest image from ECR.
log "Pulling image ${ECR_REPO_URI}..."
docker pull "${ECR_REPO_URI}"

# Check if a container with the same name exists, then force-remove it.
if [ "$(docker ps -aq -f name=${CONTAINER_NAME})" ]; then
    log "Existing container '${CONTAINER_NAME}' found. Removing it..."
    docker rm -f "${CONTAINER_NAME}"
fi

# Run the container with a restart policy.
log "Starting container '${CONTAINER_NAME}'..."
docker run -d \
  --name "${CONTAINER_NAME}" \
  -p 8002:8002 \
  --restart unless-stopped \
  "${ECR_REPO_URI}"

log "Container '${CONTAINER_NAME}' is now running."
