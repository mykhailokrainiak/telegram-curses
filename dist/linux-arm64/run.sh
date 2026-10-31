#!/bin/sh
set -eu
APP_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
export LD_LIBRARY_PATH="$APP_DIR/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export LANG=C.UTF-8
if [ -n "${WSL_DISTRO_NAME:-}" ]; then
  export TELEGRAM_CURSES_DISABLE_DESKTOP_NOTIFICATIONS=1
fi
exec "$APP_DIR/telegram-curses" "$@"
