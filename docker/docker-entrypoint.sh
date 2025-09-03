#!/bin/bash
set -euo pipefail
export HOME=/config
export XAUTHORITY=~/.Xauthority

GAME_DIR="/data/Stardew/Stardew Valley"
GAME_BIN="$GAME_DIR/StardewValley"

# Make sure game is executable and run from its directory
mkdir -p "$GAME_DIR"
chmod +x "$GAME_BIN" 2>/dev/null || true
cd "$GAME_DIR" || exit 1

# Launch via xterm to surface any errors in the GUI
exec xterm -fa Monospace -fs 11 -hold -e bash -lc 'set -e; if [ -x ./StardewValley ]; then ./StardewValley; else mono "Stardew Valley.exe"; fi'
