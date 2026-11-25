#!/bin/sh
set -eu

: "${TOGETHER_API_KEY:?TOGETHER_API_KEY is required}"
: "${API_SERVER_KEY:?API_SERVER_KEY is required}"

LUKE_HERMES_DIR="${LUKE_HERMES_DIR:-/opt/luke-hermes}"

mkdir -p "$HERMES_HOME"
cp "$LUKE_HERMES_DIR/config.yaml" "$HERMES_HOME/config.yaml"

# OpenSEO: the MCP server and its skills are added only when OPENSEO_API_KEY is set, so Hermes starts the same as
# before without it. The key never reaches the disk: the config holds the ${OPENSEO_API_KEY} reference and Hermes
# reads the value from this process's environment when it connects.
if [ -n "${OPENSEO_API_KEY:-}" ]; then
  openseo_url="${OPENSEO_MCP_URL:-https://app.openseo.so/mcp}"
  case "$openseo_url" in
    *[\"\\[:space:]]*) openseo_url="" ;;
    https://?*|http://?*) ;;
    *) openseo_url="" ;;
  esac
  if [ -z "$openseo_url" ]; then
    echo "start-hermes: OPENSEO_MCP_URL must be an http(s) URL without spaces or quotes; OpenSEO is not enabled." >&2
  else
    cat >>"$HERMES_HOME/config.yaml" <<EOF

# Added by start-hermes.sh because OPENSEO_API_KEY is set.
skills:
  external_dirs:
    - $LUKE_HERMES_DIR/skills/openseo

mcp_servers:
  openseo:
    url: "$openseo_url"
    headers:
      Authorization: "Bearer \${OPENSEO_API_KEY}"
EOF
    echo "start-hermes: OpenSEO MCP server enabled at $openseo_url" >&2
  fi
fi

export API_SERVER_ENABLED=true
export API_SERVER_HOST=0.0.0.0
export API_SERVER_PORT="${PORT:-8642}"
export API_SERVER_MODEL_NAME=hermes-agent

exec hermes gateway run
