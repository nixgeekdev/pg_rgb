#!/usr/bin/env bash
set -e

# Get the directory of this executing script -- adapted rom https://stackoverflow.com/a/246128
BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

function usage() {
  echo "Usage:"
  echo "$0 up|down|status|bounce|clean"
  exit 1
}

if [ $# -eq 0 ]; then
  usage
fi

INVOKE_FUNC=$1

function down() {
    docker-compose down --remove-orphans --volumes
    status
}

function status() {
    docker-compose ps
}

function bounce() {
    down
    up
}

function clean() {
    docker image ls -a
    docker container ls -a
    docker volume ls
    docker system prune --all -f
    docker volume prune --all -f
}

function up() {
    docker compose up db
    status
}

# shellcheck disable=SC2086
${INVOKE_FUNC}

