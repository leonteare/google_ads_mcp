#!/bin/sh
set -e

# Railway provides PORT; FastMCP reads FASTMCP_PORT
export FASTMCP_PORT="${PORT:-8000}"
# Bind to all interfaces so Railway can route traffic
export FASTMCP_HOST="0.0.0.0"

# Generate google-ads.yaml from env vars if the file doesn't already exist
CREDS_PATH="${GOOGLE_ADS_CREDENTIALS:-/app/google-ads.yaml}"
if [ ! -f "$CREDS_PATH" ] && [ -n "$GOOGLE_ADS_DEVELOPER_TOKEN" ]; then
  cat > "$CREDS_PATH" <<EOF
developer_token: "${GOOGLE_ADS_DEVELOPER_TOKEN}"
client_id: "${GOOGLE_ADS_CLIENT_ID}"
client_secret: "${GOOGLE_ADS_CLIENT_SECRET}"
refresh_token: "${GOOGLE_ADS_REFRESH_TOKEN}"
login_customer_id: "${GOOGLE_ADS_LOGIN_CUSTOMER_ID}"
use_proto_plus: true
EOF
  export GOOGLE_ADS_CREDENTIALS="$CREDS_PATH"
  echo "Generated google-ads.yaml from environment variables"
fi

exec run-mcp-server "$@"
