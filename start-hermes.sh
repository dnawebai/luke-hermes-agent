#!/bin/sh
set -eu

: "${TOGETHER_API_KEY:?TOGETHER_API_KEY is required}"
: "${API_SERVER_KEY:?API_SERVER_KEY is required}"

mkdir -p "$HERMES_HOME"
cp /opt/luke-hermes/config.yaml "$HERMES_HOME/config.yaml"

export API_SERVER_ENABLED=true
export API_SERVER_HOST=0.0.0.0
export API_SERVER_PORT="${PORT:-8642}"
export API_SERVER_MODEL_NAME=hermes-agent

exec hermes gateway run
