# Linux-Scripts

## Speedup pendrives:

sudo modprobe ehci_hcd

## ACL Fix for Directories:

chmod g+rwxs /path/to/parent

setfacl -dm u::rwx,g::rwx,o::rwx /shared/directory

## Create WINE Icon:

sudo apt install icoutils

Extract Icone:

wrestool -x -t 14 source.exe > output.ico

WINEPREFIX=/home/nathandrake/.PlayOnLinux/wineprefix/TheSims4

WINEARCH=win64

## Tips to Fix hard disks:

sudo smartctl -t short /dev/sdX

sudo smartctl -l selftest /dev/sdX

sudo hdparm --write-sector 187175297 --yes-i-know-what-i-am-doing /dev/sdX

## Fix NTFS with Linux

sudo ntfsfix -d -b /dev/sdXY

## How to see your actual external IP (WAN)

dig @resolver4.opendns.com myip.opendns.com +short

## SFTP with FSTAB

apt install sshfs

On fstab:

user@host:/remote/dir  /local/mountpoint  fuse.sshfs  defaults  0  0

Adjust sshd.conf to keep it alive!

## Temp to RAM with FSTAB

tmpfs /tmp tmpfs defaults 0 0

tmpfs /var/tmp tmpfs defaults 0 0

## Uploading some files to nextcloud through SSH:

curl -k -T ARQUIVO_LOCAL -u "ID_DA_PASTA:SENHA_DE_USUÁRIO" -H 'X-Requested-With: XMLHttpRequest' https://cs.unixuniverse.com.br/cloud/public.php/webdav/NOME_DO_ARQUIVO_NO_SERVIDOR

## Mount .RAW disks from QEMU KVM!

sudo apt install guestfs-tools

sudo guestmount --add /path/to/disk.img --mount /dev/sda2 /mnt/temp

## X11 connection rejected because of wrong authentication...

export DISPLAY=localhost:10.0

xauth add ${HOST}:10 . $(xxd -l 16 -p /dev/urandom)

sudo xauth merge ~/.Xauthority

## Resize EXT4

First: Check if there is a partition table! If disk was made with mkfs.xxx /dev/sdX, then will not be a partition table. Not possible to resize.

sudo e2fsck -f /dev/sdf

sudo resize2fs /dev/sdf 404G
