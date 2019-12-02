#!/bin/sh
set -e

function main() {
  sanitize "${AWS_ACCESS_KEY_ID}" "access_key_id"
  sanitize "${AWS_SECRET_ACCESS_KEY}" "secret_access_key"
  sanitize "${AWS_DEFAULT_REGION}" "region"
  sanitize "${AWS_ACCOUNT_ID}" "account_id"
  sanitize "${INPUT_REPO}" "repo"

  ACCOUNT_URL="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com"

  login
  docker_build $INPUT_TAGS $ACCOUNT_URL
  create_ecr_repo $INPUT_CREATE_REPO
  docker_push_to_ecr $INPUT_TAGS $ACCOUNT_URL
}

function sanitize() {
  if [ -z "${1}" ]; then
    >&2 echo "Unable to find the ${2}. Did you set with.${2}?"
    exit 1
  fi
}

function login() {
  echo "== START LOGIN"
  LOGIN_COMMAND=$(aws ecr get-login --no-include-email --region $AWS_DEFAULT_REGION)
  $LOGIN_COMMAND
  echo "== FINISHED LOGIN"
}

function create_ecr_repo() {
  if [ "${1}" = true ]; then
    echo "== START CREATE REPO"
    aws ecr describe-repositories --region $AWS_DEFAULT_REGION --repository-names $INPUT_REPO > /dev/null 2>&1 || \
      aws ecr create-repository --region $AWS_DEFAULT_REGION --repository-name $INPUT_REPO
    echo "== FINISHED CREATE REPO"
  fi
}

function docker_build() {
  echo "== START DOCKERIZE"
  local TAG=$1
  local docker_tag_args=""
  local DOCKER_TAGS=$(echo "$TAG" | tr "," "\n")
  for tag in $DOCKER_TAGS; do
    docker_tag_args="$docker_tag_args -t $2/$INPUT_REPO:$tag"
  done

  if [ ! -z "${INPUT_CWD}" ]; then cd ${INPUT_CWD}; fi
  pwd
  docker build $INPUT_EXTRA_BUILD_ARGS -f $INPUT_DOCKERFILE $docker_tag_args $INPUT_PATH
  echo "== FINISHED DOCKERIZE"
}

function docker_push_to_ecr() {
  echo "== START PUSH TO ECR"
  local TAG=$1
  local DOCKER_TAGS=$(echo "$TAG" | tr "," "\n")
  for tag in $DOCKER_TAGS; do
    docker push $2/$INPUT_REPO:$tag
  done
  echo "== FINISHED PUSH TO ECR"
}

main
