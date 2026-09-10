#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm dbus chafa openssl tmux

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#SKIP_INTEGRITY_CHECK=1 make-aur-package oxicord-bin

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
echo "Getting app..."
echo "---------------------------------------------------------------"
mkdir -p ./AppDir/bin
TAG=$(wget -qO- https://api.github.com/repos/linuxmobile/oxicord/releases/latest | grep -oP '"tag_name": "\K[^"]+')
VERSION=${TAG#v}
echo "$VERSION" > ~/version

LINK=$(wget -qO- https://api.github.com/repos/linuxmobile/oxicord/releases/latest \
      | grep -oP "https://[^\"]+$ARCH--unknown-linux-gnu[^\"]*")
if ! wget --retry-connrefused --tries=30 "$LINK" -O ./AppDir/bin/oxicord 2>/tmp/download.log; then
    cat /tmp/download.log
    exit 1
fi
