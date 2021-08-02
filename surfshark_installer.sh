#!/bin/bash

: <<'END_COMMENT'
This program is free software. It comes without any warranty, to
     * the extent permitted by applicable law. You can redistribute it
     * and/or modify it under the terms of the Do What The Fuck You Want
     * To Public License, Version 2, as published by Sam Hocevar. See
     * http://www.wtfpl.net/ for more details.
END_COMMENT

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

VERSION=1.1.0
DISTRONAME="$(cat /etc/os-release | grep '^NAME' | cut -d\= -f2-  | sed 's/\"//g')"


echo "Installing Openvpn Dependency..."
if [[ -n "$(echo $DISTRONAME | grep -oi opensuse)" ]]; then
    zypper in openvpn
elif [[ -n "$(echo $DISTRONAME | grep -oi gentoo)" ]]; then
    emerge -av net-vpn/openvpn
elif [[ -n "$(echo $DISTRONAME | grep -oi fedora)" ]]; then
    dnf install openvpn
elif [[ -n "$(echo $DISTRONAME | grep -oi arch)" ]]; then
    echo "Just install surfshark-vpn from AUR"
    exit 0
elif [[ -n "$(echo $DISTRONAME | grep -oi void)" ]]; then
    xbps-install -S openvpn
else
    echo "Unknown distro, aborting..."
    exit 1
fi



echo "Downloading Surfshark Deb Package"
_tmp="$(mktemp -d)"
pushd ${_tmp}
wget -O surfshark.deb "https://ocean.surfshark.com/debian/pool/main/s/surfshark-vpn/surfshark-vpn_${VERSION}_amd64.deb"



echo "Done, Installing Now"
ar x surfshark.deb
tar xvf data.tar.xz
sudo install -Dm 755 "usr/bin/surfshark-vpn" -t "/usr/local/bin/"
popd
rm -rf ${_tmp}
echo "All Done"
