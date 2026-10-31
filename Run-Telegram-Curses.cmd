@echo off
setlocal
set "WSL_DISTRO=Ubuntu-24.04"
for /f "delims=" %%P in ('wsl.exe -d %WSL_DISTRO% -- wslpath -a -u "%~dp0."') do set "PROJECT_WSL=%%P"
if not defined PROJECT_WSL (
  echo Unable to locate the repository in WSL. Check WSL_DISTRO in this launcher.
  exit /b 1
)
wt.exe -w 0 new-tab --title "Telegram Curses ARM64" wsl.exe -d %WSL_DISTRO% -- bash "%PROJECT_WSL%/scripts/open-wsl.sh"
