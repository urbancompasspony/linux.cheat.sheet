#!/bin/bash

clear
echo "Setting strings"
dname=rtl8192eu
dver=1.0
dusrdir=/usr/src/$dname-$dver
ddkmsdir=/var/lib/dkms/$dname

clear
echo "make and make install"
sudo make ARCH="arm64"
sudo make install

clear
echo "rmmod"
sudo rmmod 8192eu
sudo rmmod rtl8xxxu

clear
echo "dkms remove"
sudo dkms uninstall -m $dname -v $dver
sudo dkms remove -m $dname -v $dver
sudo rm -r $dusrdir
sudo rm -r $ddkmsdir

clear
echo "mkdir"
sudo mkdir $dusrdir
sudo cp -ar . $dusrdir

clear
echo "dkms ADD and INSTALL"
sudo dkms add -m $dname -v $dver
sudo dkms install -m $dname -v $dver
sudo depmod -a

clear
echo "Some settings"
echo "blacklist rtl8xxxu" | sudo tee /etc/modprobe.d/blacklist-rtl8xxxu.conf
echo "options 8192eu rtw_power_mgnt=0 rtw_enusbss=0" | sudo tee /etc/modprobe.d/8192eu.conf
echo -e "8192eu\n\nloop" | sudo tee /etc/modules

clear
echo "the end"
#sudo update-initramfs -u
sudo modprobe 8192eu
