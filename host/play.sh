#!/usr/bin/env bash
# Launch Proven Goose Pond with the local Bend 2 loader on PATH.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HOST="$ROOT/host"

if ! command -v bun >/dev/null 2>&1; then
  echo "bun is required. Install from https://bun.sh" >&2
  exit 1
fi

BEND_HOME="${BEND_HOME:-$HOME/.bend}"
BEND_MAIN="$BEND_HOME/current/bend2/main.ts"
if [[ ! -f "$BEND_MAIN" ]]; then
  echo "Bend 2 not found at $BEND_MAIN" >&2
  echo "Install with: curl -fsSL https://bend-lang.com/install.sh | sh" >&2
  exit 1
fi

cat > "$HOST/bunfig.toml" <<EOF
preload = ["$BEND_MAIN"]

[serve.static]
plugins = ["$BEND_MAIN"]
EOF

cd "$HOST"
exec bun play.mjs "$@"
