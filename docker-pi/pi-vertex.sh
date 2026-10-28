#!/bin/bash
set -euo pipefail

THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

AGENTS_MD=AGENTS.md
PI_IMAGE=pi-sandbox
PI_AGENT_HOME=/root/.pi/agent
PI_AGENT_HOME_VOLUME=pi-agent-home

docker run --rm --interactive --tty \
  -e GOOGLE_CLOUD_PROJECT=$(cat $HOME/.config/gcloud/configurations/config_default | grep project | awk '{print $3}') \
  -e GOOGLE_CLOUD_LOCATION=global \
  -v "$HOME/.config/gcloud:/root/.config/gcloud:ro" \
  -v "$PI_AGENT_HOME_VOLUME":"$PI_AGENT_HOME" \
  -v "$THIS_DIR/$AGENTS_MD":"$PI_AGENT_HOME/$AGENTS_MD:ro" \
  -v "$PWD:/workspace" \
  pi-sandbox
