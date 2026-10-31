#!/bin/bash
set -euo pipefail
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
BUILD=${BUILD_DIR:-"$ROOT/build-arm64"}
if [ "$(uname -m)" != aarch64 ]; then
  echo 'This script builds natively on Linux ARM64 (aarch64).' >&2
  exit 1
fi
git -C "$ROOT" submodule update --init --recursive td third-party/notcurses third-party/rlottie
PATCH="$ROOT/patches/notcurses-terminal-timeout.patch"
NOTCURSES="$ROOT/third-party/notcurses"
if git -C "$NOTCURSES" apply --reverse --check "$PATCH" 2>/dev/null; then
  echo 'Notcurses terminal timeout patch already applied.'
elif git -C "$NOTCURSES" apply --check "$PATCH"; then
  git -C "$NOTCURSES" apply "$PATCH"
else
  echo 'Notcurses patch conflicts with local changes; resolve them before building.' >&2
  exit 1
fi
cmake -S "$ROOT" -B "$BUILD" -G Ninja -DCMAKE_BUILD_TYPE=Release \
  -DUSE_PANDOC=OFF -DBUILD_EXECUTABLES=OFF -DUSE_POC=OFF \
  -DBUILD_TESTING=OFF -DUSE_DOCTEST=OFF
cmake --build "$BUILD" --target telegram-curses --parallel "${JOBS:-3}"
OUT="$ROOT/dist/linux-arm64"
mkdir -p "$OUT/lib"
install -m755 "$BUILD/telegram-curses-0.4.0" "$OUT/telegram-curses.new"
strip "$OUT/telegram-curses.new"
mv -f "$OUT/telegram-curses.new" "$OUT/telegram-curses"
find "$BUILD/third-party" -type f -name '*.so*' -exec cp -t "$OUT/lib" {} +
strip "$OUT"/lib/*.so*
cd "$OUT/lib"
for lib in *.so.*; do
  soname=$(readelf -d "$lib" | sed -n 's/.*(SONAME).*\[\(.*\)\].*/\1/p')
  if [ -n "$soname" ] && [ "$soname" != "$lib" ]; then
    # Regular SONAME files also work when Windows Git cannot create symlinks.
    cp --remove-destination "$lib" "$soname"
  fi
done
echo 'Native ARM64 build ready. Run bash dist/linux-arm64/run.sh from the repository.'
