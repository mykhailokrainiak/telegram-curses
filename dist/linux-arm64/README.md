# Native Linux ARM64 build

`telegram-curses` and the bundled Notcurses/rlottie libraries are AArch64 ELF binaries built on Ubuntu 24.04. They do not use x86 emulation.

Run `bash dist/linux-arm64/run.sh` from the repository root, or use the Windows launcher described in the main README.

The build includes the UI refresh, legacy keyboard input fix, terminal startup timeout, and terminal resize handling. The launcher disables desktop notification popups in WSL because a missing desktop service can block the UI thread. In-app unread indicators remain active, and Telegram account settings are unchanged.

System libraries are required; this is not a fully static executable. See the main README for runtime dependencies and native rebuild instructions. Rebuilding updates the binary and bundled libraries in this directory.
