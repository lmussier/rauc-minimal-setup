#!/bin/bash

##########################
echo "Installing prerequistes"
##########################

sudo apt-get install build-essential meson libtool libdbus-1-dev libglib2.0-dev libcurl3-dev libssl-dev libnl-genl-3-dev libjson-glib-dev

##########################
echo "Getting rauc"
##########################

git clone https://github.com/rauc/rauc.git --branch=v1.10.1

echo "Building rauc"
cd rauc
meson setup build
meson compile -C build

##########################
echo "Configuring stuff"
##########################

cd build

echo "[system]
compatible=Test Config
bootloader=custom

[handlers]
bootloader-custom-backend=custom-bootloader-script

[keyring]
path=dev-ca.pem

[slot.rootfs.0]
device=images/rootfs-0
type=raw

[slot.appfs.0]
device=images/rootfs-0/appfs-0
type=ext4
parent=rootfs.0



[slot.rootfs.1]
device=images/rootfs-1
type=raw
bootname=$(df /boot | grep -Eo '/dev/[^ ]+')" > minimal_system.conf

# This is just make the rauc bundle happy

mkdir -p images/rootfs-0/appfs-0
mkdir -p images/rootfs-0/appfs-1

# Activatinvating nbd on the machine
sudo modprobe nbd


##########################
echo "Getting cert for signature verification"
##########################

wget https://raw.githubusercontent.com/rauc/rauc/v1.10.1/test/openssl-ca/dev-ca.pem

##########################
echo "Testing rauc info"
##########################

./rauc --debug --conf minimal_system.conf info https://github.com/rauc/rauc/raw/a1ca6126a8414553bcc2c3f793e6ffb4faf3bf84/test/good-verity-bundle.raucb

##########################
echo "Testing rauc install"
##########################

sudo ./rauc --debug --conf minimal_system.conf service &

sleep 3

./rauc --debug --conf minimal_system.conf install https://github.com/rauc/rauc/raw/a1ca6126a8414553bcc2c3f793e6ffb4faf3bf84/test/good-verity-bundle.raucb

sudo kill $(pidof rauc)
# TTY fucked up after all this, make it work correclty...
stty sane
