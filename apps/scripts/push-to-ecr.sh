#!/usr/bin/env bash
set -euo pipefail

# Config — change as needed
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
REPOSITORY_PREFIX="dvn-workshop/production"   # ECR repo path prefix
APPS=("backend" "frontend")                    # folders under ./apps/ (this script should live in ./apps/)
BUILD_CONTEXT_ROOT="."                         # each app path is ./${APP}
DOCKERFILE_NAME="Dockerfile"                   # assumes each app has Dockerfile at its root
VERSION="V1.3"

# Optional: create SHA tag
GIT_SHA="$(git rev-parse --short HEAD 2>/dev/null || echo "no-git")"
DATE_TAG="$(date +%Y%m%d%H%M%S)"
TAGS=("${VERSION}" "${GIT_SHA}" "${DATE_TAG}")

echo "Logging into ECR: ${ECR_REGISTRY}"
aws ecr get-login-password --region "${AWS_REGION}" \
  | docker login --username AWS --password-stdin "${ECR_REGISTRY}"

for APP in "${APPS[@]}"; do
  APP_PATH="${BUILD_CONTEXT_ROOT}/${APP}"
  if [[ ! -d "${APP_PATH}" ]]; then
    echo "Skipping ${APP}: directory not found at ${APP_PATH}" >&2
    continue
  fi
  if [[ ! -f "${APP_PATH}/${DOCKERFILE_NAME}" ]]; then
    echo "Skipping ${APP}: ${DOCKERFILE_NAME} not found in ${APP_PATH}" >&2
    continue
  fi

  LOCAL_NAME="${REPOSITORY_PREFIX}/${APP}"
  REMOTE_REPO="${ECR_REGISTRY}/${REPOSITORY_PREFIX}/${APP}"

  echo ""
  echo "=== Building ${APP} ==="
  docker buildx build --no-cache -f "${APP_PATH}/${DOCKERFILE_NAME}" -t "${LOCAL_NAME}:${VERSION}" "${APP_PATH}"
  
  # Ensure ECR repo exists (idempotent)
  if ! aws ecr describe-repositories --repository-names "${REPOSITORY_PREFIX}/${APP}" --region "${AWS_REGION}" >/dev/null 2>&1; then
    echo "ECR repo ${REPOSITORY_PREFIX}/${APP} not found. Creating..."
    aws ecr create-repository --repository-name "${REPOSITORY_PREFIX}/${APP}" --region "${AWS_REGION}" >/dev/null
  fi

  # Tag and push all tags
  for TAG in "${TAGS[@]}"; do
    echo "Tagging ${LOCAL_NAME}:${VERSION} -> ${REMOTE_REPO}:${TAG}"
    docker tag "${LOCAL_NAME}:${VERSION}" "${REMOTE_REPO}:${TAG}"

    echo "Pushing ${REMOTE_REPO}:${TAG}"
    docker push "${REMOTE_REPO}:${TAG}"
  done
done

echo ""
echo "All done."