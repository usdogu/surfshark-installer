#!/bin/bash

: <<'END_COMMENT'
This program is free software. It comes without any warranty, to
     * the extent permitted by applicable law. You can redistribute it
     * and/or modify it under the terms of the Do What The Fuck You Want
     * To Public License, Version 2, as published by Sam Hocevar. See
     * http://www.wtfpl.net/ for more details.
END_COMMENT


VERSION=1.1.0
DISTRONAME="$(cat /etc/os-release | grep '^NAME' | cut -d\= -f2-  | sed 's/\"//g')"


echo "Installing Openvpn Dependency..."
if [[ -n "$(echo $DISTRONAME | grep -oi opensuse)" ]]; then
    sudo zypper in openvpn
elif [[ -n "$(echo $DISTRONAME | grep -oi gentoo)" ]]; then
    sudo emerge -av net-vpn/openvpn
elif [[ -n "$(echo $DISTRONAME | grep -oi fedora)" ]]; then
    sudo dnf install openvpn
elif [[ -n "$(echo $DISTRONAME | grep -oi arch)" ]]; then
    echo "Just Install surfshark-vpn from AUR"
    exit 0
else
    echo "Unknown distro, aborting..."
    exit 1
fi



echo "Downloading Surfshark Deb Package"
_tmp="$(mktemp -d)"
pushd ${_tmp}
wget -O surfshark.deb "https://ocean.surfshark.com/debian/pool/main/s/surfshark-vpn/surfshark-vpn_${VERSION}_amd64.deb"



echo "Done, Installing Now"
mkdir surfshark_work
ar x --output surfshark_work surfshark.deb
cd surfshark_work
tar xvf data.tar.xz
sudo install -Dm 755 "usr/bin/surfshark-vpn" -t "/usr/local/bin/"
popd
rm -rf ${_tmp}
echo "All Done"



