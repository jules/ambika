#!/usr/bin/env bash

# set -x

# fix apt warnings like:
# ==> default: dpkg-preconfigure: unable to re-open stdin: No such file or directory
# http://serverfault.com/questions/500764/dpkg-reconfigure-unable-to-re-open-stdin-no-file-or-directory
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales

# fix apt warnings like:
# ==> default: dpkg-preconfigure: unable to re-open stdin: No such file or directory
# http://serverfault.com/questions/500764/dpkg-reconfigure-unable-to-re-open-stdin-no-file-or-directory
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales

# Install some additional drivers, including support for FTDI dongles
# http://askubuntu.com/questions/541443/how-to-install-usbserial-and-ftdi-sio-modules-to-14-04-trusty-vagrant-box
sudo apt-get update -qq
sudo apt-get install -y linux-image-extra-virtual
sudo modprobe ftdi_sio vendor=0x0403 product=0x6001

# Install basic development tools
sudo dpkg --add-architecture i386
sudo apt-get update -qq
sudo apt-get install -y build-essential autotools-dev autoconf pkg-config libusb-1.0-0 libusb-1.0-0-dev libftdi1 libftdi-dev git libc6:i386 libncurses5:i386 libstdc++6:i386 cowsay figlet language-pack-en
sudo locale-gen UTF-8

# Install python
sudo apt-get install -y python2.7 python-numpy python-scipy python-matplotlib

# Install development tools for avr
sudo apt-get install -y gcc-avr binutils-avr avr-libc avrdude
export AVRPATH=`which avr-gcc`
sed "s|AVRLIB_TOOLS_PATH ?=.*|AVRLIB_TOOLS_PATH \?= `dirname $AVRPATH`/|" /vagrant/avrlib/makefile.mk > mkfiletmp
mv mkfiletmp /vagrant/avrlib/makefile.mk



# Allow non-root users to access USB devices such as Atmel AVR and Olimex
# programmers, FTDI dongles...
echo 'SUBSYSTEMS=="usb", ATTRS{idVendor}=="15ba", ATTRS{idProduct}=="0003", GROUP="users", MODE="0666"' >> /etc/udev/rules.d/60-programmers.rules
echo 'SUBSYSTEMS=="usb", ATTRS{idVendor}=="15ba", ATTRS{idProduct}=="002a", GROUP="users", MODE="0666"' >> /etc/udev/rules.d/60-programmers.rules
echo 'SUBSYSTEMS=="usb", ATTRS{idVendor}=="15ba", ATTRS{idProduct}=="002b", GROUP="users", MODE="0666"' >> /etc/udev/rules.d/60-programmers.rules
echo 'SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2104", GROUP="users", MODE="0666"' >> /etc/udev/rules.d/60-programmers.rules
echo 'SUBSYSTEMS=="usb", KERNEL=="ttyUSB*", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", GROUP="users", MODE="0666", SYMLINK+="ftdi-usbserial"' >> /etc/udev/rules.d/60-programmers.rules
sudo udevadm control --reload-rules
sudo udevadm trigger


# Add "." to PYTHONPATH, and set default language
echo 'export LC_ALL=en_US.UTF-8' >> /home/vagrant/.bashrc
echo 'export LANGUAGE=en_US' >> /home/vagrant/.bashrc
echo 'export PYTHONPATH=.:$PYTHONPATH' >> /home/vagrant/.bashrc
