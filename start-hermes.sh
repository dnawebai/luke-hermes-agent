#!/bin/sh
set -eu

mkdir -p "$HERMES_HOME"
mkdir -p "$HERMES_HOME/.hermes"
cp /opt/luke-hermes/config.yaml "$HERMES_HOME/.hermes/config.yaml"

export API_SERVER_ENABLED=true
export API_SERVER_HOST=0.0.0.0
export API_SERVER_PORT="${PORT:-8642}"
export API_SERVER_MODEL_NAME=hermes-agent

exec hermes gateway
