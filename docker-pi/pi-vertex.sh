#!/bin/bash
set -euo pipefail

THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

AGENTS_MD=AGENTS.md
PI_IMAGE=pi-sandbox
PI_AGENT_HOME=/home/node.pi/agent
PI_AGENT_HOME_VOLUME=pi-agent-home

if ! docker image inspect "$PI_IMAGE" &>/dev/null; then
  echo "Image '$PI_IMAGE' not found. Building..."
  docker build -t "$PI_IMAGE" "$THIS_DIR"
fi

docker run --rm --interactive --tty \
  -e GOOGLE_CLOUD_PROJECT=$(cat $HOME/.config/gcloud/configurations/config_default | grep project | awk '{print $3}') \
  -e GOOGLE_CLOUD_LOCATION=global \
  -v "$HOME/.config/gcloud:/home/node/.config/gcloud:ro" \
  -v "$PI_AGENT_HOME_VOLUME":"$PI_AGENT_HOME" \
  -v "$THIS_DIR/$AGENTS_MD":"$PI_AGENT_HOME/$AGENTS_MD:ro" \
  -v "$PWD:/workspace" \
  "$PI_IMAGE" "$@"
