# Linux-Scripts

Speedup pendrives:
sudo modprobe ehci_hcd

ACL Fix for Directories:
chmod g+rwxs /path/to/parent
setfacl -dm u::rwx,g::rwx,o::rwx /shared/directory

