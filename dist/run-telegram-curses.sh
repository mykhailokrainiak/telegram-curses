#!/bin/sh

set -e

DIST_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
export LD_LIBRARY_PATH="$DIST_DIR/third-party/notcurses:$DIST_DIR/third-party/rlottie${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

exec "$DIST_DIR/telegram-curses-0.4.0" "$@"
