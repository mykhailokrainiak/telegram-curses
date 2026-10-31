# Telegram Curses

A keyboard-driven Telegram client built with TDLib and Notcurses.

The terminal UI includes a wider chat sidebar, dark slate colours, blue selection, pane labels, a welcome screen, and a persistent shortcut bar. The status line shows the connection state and unread chats.

## Run on ARM64 WSL2

The native AArch64 build in `dist/linux-arm64/` was built and tested on Ubuntu 24.04 ARM64 under WSL2. It does not require x86 emulation. The older x86-64 build remains under `dist/` for x86-64 Linux.

Install runtime dependencies inside Ubuntu 24.04:

```bash
sudo apt update
sudo apt install -y tmux libglib2.0-0t64 libgdk-pixbuf-2.0-0 libnotify4 \
  libconfig++9v5 libutf8proc3 libjpeg8 libssl3t64 libdeflate0 libunistring5 \
  libncursesw6 libavcodec60 libavdevice60 libavformat60 libavutil58 libswscale7
```

Then run from the repository root:

```bash
bash dist/linux-arm64/run.sh
```

From Windows, double-click `Run-Telegram-Curses.cmd`. It opens a separate Windows Terminal tab in the existing `Ubuntu-24.04` WSL distribution. Change `WSL_DISTRO` in the launcher if your distribution has another name. This does not restart WSL or affect existing tmux sessions.

The Windows launcher uses a dedicated tmux server and theme. Press **Ctrl+B**, then **D** to detach; run the launcher again to reconnect.

Sign in using the QR code and, if requested, your Telegram two-step verification password. Password input is masked with `*`.

Desktop notification popups are disabled by the launcher under WSL because a missing or unresponsive desktop service can block the UI. In-app unread indicators remain enabled; your Telegram account's notification settings are unchanged. Native Linux users can opt out of desktop popups by setting `TELEGRAM_CURSES_DISABLE_DESKTOP_NOTIFICATIONS=1`.

## Keyboard navigation

| Key | Action |
| --- | --- |
| Up / Down or k / j | Select a chat or message |
| Enter | Open a selected chat; show actions for a selected message |
| Tab | Switch between chat list and conversation |
| s | Find a chat to open |
| / | Search in the current conversation |
| f | Choose a chat folder, while focused on the chat list |
| i | Compose a message in an open conversation |
| Esc | Close a popup; in the chat list, ask to exit |
| F1 | Full keyboard help |
| F7 | Settings |
| Ctrl+A, then h / l | Move focus left / right |
| Ctrl+R | Redraw |

## Build natively for ARM64

Inside Ubuntu 24.04 ARM64, install the build dependencies:

```bash
sudo apt install -y build-essential cmake ninja-build doctest-dev \
  libavdevice-dev libdeflate-dev libncurses-dev libqrcodegen-dev \
  libswscale-dev libunistring-dev pkg-config python3-cffi python3-dev \
  python3-setuptools gperf libssl-dev libgdk-pixbuf-2.0-dev libglib2.0-dev \
  libtermkey-dev libunibilium-dev libutf8proc-dev libconfig++-dev \
  libnotify-dev libicu-dev
bash scripts/build-arm64.sh
```

The script initializes the pinned submodules, applies the bundled terminal timeout patch to Notcurses, builds the application, and packages the executable and custom shared libraries in `dist/linux-arm64/`. Repeated builds recognize the already-applied patch. It intentionally leaves that submodule locally modified; do not reset it while building. Set `JOBS` to change the default of three compiler jobs, or `BUILD_DIR` to choose another build directory.

The binary uses system libraries and is not fully static. The source includes fixes for legacy key events without explicit press metadata, incomplete terminal startup responses, and terminal resizing. The UI was verified at 80x24 and 120x40, including opening help with F1 and closing it with Escape.

## Local data

Configuration is stored in `~/.config/telegram-curses/config`; account data is stored in `~/.local/share/telegram-curses/`. These locations are inside the Linux distribution when using WSL. Neither is included in this repository.
