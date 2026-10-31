#!/bin/bash
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
printf -v command 'bash %q' "$ROOT/dist/linux-arm64/run.sh"
exec tmux -L telegram-curses-arm64 -f "$ROOT/dist/linux-arm64/tmux.conf" \
  new-session -A -s telegram-curses "$command"
