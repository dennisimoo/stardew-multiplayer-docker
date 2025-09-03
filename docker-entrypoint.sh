#!/bin/bash
set -euo pipefail
export HOME=/config

# Minimal launch without mods/SMAPI
export XAUTHORITY=~/.Xauthority

# Ensure launcher uses xterm so we can see logs in the GUI
if grep -q 'env TERM=xterm \$LAUNCHER' "/data/Stardew/Stardew Valley/StardewValley" 2>/dev/null; then
  sed -i -e 's/env TERM=xterm $LAUNCHER \"$@\"$/env SHELL=\\/bin\\/bash TERM=xterm xterm -e \"\\/bin\\/bash -c $LAUNCHER \"$@\"\"/' \
    "/data/Stardew/Stardew Valley/StardewValley" || true
fi

exec bash -c "/data/Stardew/Stardew\\ Valley/StardewValley"
