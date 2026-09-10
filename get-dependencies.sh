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

LINK=$(wget https://api.github.com/repos/linuxmobile/oxicord/releases -O - \
      | sed 's/[()",{} ]/\n/g' | grep -o -m 1 "https.*$ARCH")
echo "$LINK" | awk -F'/' '{gsub(/^v/, "", $(NF-1)); print $(NF-1); exit}' > ~/version
if ! wget --retry-connrefused --tries=30 "$DEB_LINK" -O /tmp/app 2>/tmp/download.log; then
	cat /tmp/download.log
	exit 1
fi

mkdir -p ./AppDir/bin
