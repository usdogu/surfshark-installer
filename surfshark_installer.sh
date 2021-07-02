#!/bin/bash

VERSION=1.1.0
DISTRO=`cat /etc/os-release | grep '^NAME' | cut -d\= -f2-  | sed 's/\"//g'`

echo "Installing Openvpn Dependency"
if [[ $DISTRO == *"openSUSE"* ]]; then
    sudo zypper in openvpn
elif [[ $DISTRO == *"Gentoo"* ]]; then
    sudo emerge -v net-vpn/openvpn
elif [[ $DISTRO == *"Fedora"* ]]; then
    sudo dnf install openvpn
fi



echo "Downloading Surfshark Deb Package"
wget -O surfshark.deb "https://ocean.surfshark.com/debian/pool/main/s/surfshark-vpn/surfshark-vpn_${VERSION}_amd64.deb"

echo "Done, Installing Now"
mkdir work
ar x --output work surfshark.deb
cd work
tar xvf data.tar.xz
sudo install -Dm 755 "usr/bin/surfshark-vpn" -t "/usr/bin/"
cd ..
rm -rf work
echo "All Done"
