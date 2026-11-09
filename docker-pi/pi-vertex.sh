#!/bin/bash
set -euo pipefail

THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

AGENTS_MD=AGENTS.md
MODELS_JSON=models.json
SETTINGS_JSON=settings.json
EXTENSIONS_DIR=extensions
PI_IMAGE=pi-sandbox
PI_AGENT_HOME=/home/node/.pi/agent
PI_AGENT_HOME_VOLUME=pi-agent-home

GCLOUD_HOME="$HOME/.config/gcloud"
BIFROST_KEY_FILE="$HOME/.config/bifrost/config"

fatal() { echo "pi-vertex: $*" >&2; exit 1; }

main() {
    command -v docker &>/dev/null || fatal "docker not found on PATH"

    local mount_workspace=false
    local args=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -w|--workspace)
                mount_workspace=true
                shift
                ;;
            *)
                args+=("$1")
                shift
                ;;
        esac
    done

    # Bifrost API key on host
    [[ -f "$BIFROST_KEY_FILE" ]] || fatal "Bifrost API key file not found: $BIFROST_KEY_FILE"
    if ! read -r BIFROST_API_KEY < "$BIFROST_KEY_FILE"; then
      BIFROST_API_KEY=$(cat "$BIFROST_KEY_FILE")
    fi
    BIFROST_API_KEY=${BIFROST_API_KEY%%[[:space:]]*}
    BIFROST_API_KEY=${BIFROST_API_KEY##*[[:space:]]}
    [[ -n "$BIFROST_API_KEY" ]] || fatal "Bifrost API key file is empty: $BIFROST_KEY_FILE"
    export BIFROST_API_KEY

    # Google Cloud project from the *active* gcloud configuration
    ACTIVE_CONFIG=$(cat "$GCLOUD_HOME/active_config" 2>/dev/null || echo default)
    GOOGLE_CLOUD_PROJECT=$(awk '$1 == "project" {print $3}' "$GCLOUD_HOME/configurations/config_$ACTIVE_CONFIG" 2>/dev/null || true)
    [[ -n "$GOOGLE_CLOUD_PROJECT" ]] || fatal "No gcloud project configured in configuration '$ACTIVE_CONFIG' ($GCLOUD_HOME)"
    export GOOGLE_CLOUD_PROJECT
    export GOOGLE_CLOUD_LOCATION=global

    if ! docker image inspect "$PI_IMAGE" &>/dev/null; then
      echo "Image '$PI_IMAGE' not found. Building..."
      docker build -t "$PI_IMAGE" "$THIS_DIR"
    fi

    local docker_args=(
      --rm --interactive --tty
      -e BIFROST_API_KEY
      -e GOOGLE_CLOUD_PROJECT
      -e GOOGLE_CLOUD_LOCATION
      -v "$GCLOUD_HOME:/home/node/.config/gcloud:ro"
      -v "$PI_AGENT_HOME_VOLUME":"$PI_AGENT_HOME"
      -v "$THIS_DIR/$AGENTS_MD":"$PI_AGENT_HOME/$AGENTS_MD:ro"
      -v "$THIS_DIR/$MODELS_JSON":"$PI_AGENT_HOME/$MODELS_JSON:ro"
      -v "$THIS_DIR/$SETTINGS_JSON":"$PI_AGENT_HOME/$SETTINGS_JSON:ro"
      -v "$THIS_DIR/$EXTENSIONS_DIR":"$PI_AGENT_HOME/$EXTENSIONS_DIR:ro"
    )

    if [[ "$mount_workspace" == true ]]; then
      docker_args+=( -v "$PWD:/workspace" )
    fi

    if [[ ${#args[@]} -gt 0 ]]; then
      docker run "${docker_args[@]}" "$PI_IMAGE" "${args[@]}"
    else
      docker run "${docker_args[@]}" "$PI_IMAGE"
    fi
}

main "$@"
