#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm chafa tmux

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Getting app..."
echo "---------------------------------------------------------------"
mkdir -p ./AppDir/bin
TAG=$(wget -qO- https://api.github.com/repos/linuxmobile/oxicord/releases/latest \
      | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -1)
VERSION=${TAG#v}
echo "$VERSION" > ~/version

LINK=$(wget -qO- https://api.github.com/repos/linuxmobile/oxicord/releases/latest \
      | grep -o "https://[^\" ]*$ARCH-unknown-linux-gnu")
if ! wget --retry-connrefused --tries=30 "$LINK" -O ./AppDir/bin/oxicord 2>/tmp/download.log; then
    cat /tmp/download.log
    exit 1
fi
chmod +x ./AppDir/bin/oxicord
