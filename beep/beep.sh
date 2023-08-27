#!/bin/bash

[ "$EUID" -ne 0 ] && {
  echo "Execute esse script como Root! Saindo..."
  exit
  }

PKG_OK=$(dpkg-query -W 1> /dev/null 2> /dev/null beep && echo "sim" || echo "nao")
[ "$PKG_OK" = "nao" ] && {
  sudo apt install beep
  echo "@reboot sleep 60; bash /home/administrador/.beep.sh" > /tmp/crontab_new
  crontab -l | cat - /tmp/crontab_new > crontab.txt && crontab crontab.txt
  rm crontab.txt
}||{
  echo "Ok" > /dev/null
}

sudo modprobe pcspkr

sudo env -u SUDO_GID -u SUDO_COMMAND -u SUDO_USER -u SUDO_UID beep -f 1000 -l 200 -r 1

sudo env -u SUDO_GID -u SUDO_COMMAND -u SUDO_USER -u SUDO_UID beep -f 2000 -l 200 -r 1

sudo env -u SUDO_GID -u SUDO_COMMAND -u SUDO_USER -u SUDO_UID beep -f 3000 -l 200 -r 2

#beep -f 1000 -l 200 -r 1 && beep -f 2000 -l 200 -r 1 && beep -f 3000 -l 200 -r 2

exit 1
