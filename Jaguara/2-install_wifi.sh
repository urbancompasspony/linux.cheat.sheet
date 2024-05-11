dname=rtl8192eu
dver=1.0
dusrdir=/usr/src/$dname-$dver
ddkmsdir=/var/lib/dkms/$dname
sudo make ARCH="arm64"
sudo make install
sudo rmmod 8192eu
sudo rmmod rtl8xxxu
sudo dkms uninstall -m $dname -v $dver
sudo dkms remove -m $dname -v $dver
sudo rm -r $dusrdir
sudo rm -r $ddkmsdir
sudo mkdir $dusrdir
sudo cp -ar . $dusrdir
sudo dkms add -m $dname -v $dver
sudo dkms install -m $dname -v $dver
sudo depmod -a
echo "blacklist rtl8xxxu" | sudo tee /etc/modprobe.d/blacklist-rtl8xxxu.conf
echo "options 8192eu rtw_power_mgnt=0 rtw_enusbss=0" | sudo tee /etc/modprobe.d/8192eu.conf
echo -e "8192eu\n\nloop" | sudo tee /etc/modules
#sudo update-initramfs -u
sudo modprobe 8192eu
