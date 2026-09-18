#!/bin/sh
set -e
export PATH="$HOME/.bend/bin:$PATH"
cd "$(dirname "$0")"
bend src/game.bend -o frog-king
exec ./frog-king
