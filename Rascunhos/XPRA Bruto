FROM ubuntu:noble
SHELL [ "/bin/bash", "-c" ]

VOLUME /home/ubuntu

#### obrigatório
RUN <<EOF
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y \
            dbus-x11 \
            uuid-runtime \
            wget \
            gnupg \
            xvfb \
            x11-xserver-utils \
            python3-pip \
            python3-uinput \
            terminator \
            tmux \
            curl \
            git \
            bash-completion \
            bzip2
pip3 install pyinotify --break-system-packages
EOF

#### obrigatório
RUN <<EOF
wget -q -O- https://xpra.org/gpg.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/xpra.gpg

echo 'deb [signed-by=/etc/apt/trusted.gpg.d/xpra.gpg arch=amd64,arm64] https://xpra.org noble main' > /etc/apt/sources.list.d/xpra.list

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y xpra
EOF

#### navegadores, opcional
### chrome
RUN <<EOF
export DEBIAN_FRONTEND=noninteractive
cd /opt
curl -L https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o chrome.deb
apt-get install -y ./chrome.deb
EOF

### firefox
RUN <<EOF
cd /opt
curl -L 'https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=pt-BR' -o firefox-latest.tar.bz2
tar -xf ./firefox-latest.tar.bz2
ln -s /opt/firefox/firefox /usr/local/bin/firefox
EOF

### customizações de usuário, opcional
USER ubuntu

RUN <<EOF

cd /home/ubuntu
mkdir -pv ./.local/bin
mkdir -pv ./.local/share/fonts
mkdir -pv ./.config/tmux


curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -o /home/ubuntu/.local/share/fonts/meslo_nerd_bold.ttf
fc-cache -vf

git clone https://gitlab.com/vmath3us/devops-userspace
cp ./devops-userspace/bare-metal-tmux.conf ./.config/tmux/tmux.conf

EOF

### usuário da imagem e entrypoint, obrigatório
USER root
RUN <<EOF
cat > /usr/local/bin/xpra-entrypoint.sh <<-IS_A_ENTRYPOINT
#!/bin/bash
mkdir -p /run/user/1000/xpra
mkdir -p /run/xpra/1000
mkdir -p /run/xpra/ubuntu
chown -Rv ubuntu:ubuntu /run/user/1000
chown -Rv ubuntu:ubuntu /run/xpra
export GENERATE_PASS=\$(uuidgen)
echo "senha \$GENERATE_PASS"

dbus-send --system /org/freedesktop/DBus org.freedesktop.DBus 2>/dev/null|| dbus-daemon --system --fork 2>/dev/null
sleep 5
su -c "
    XDG_RUNTIME_DIR='/run/user/1000' \\
    DISPLAY=':80' \\
    XCURSOR_SIZE='50' \\
                        xpra start \\
                        ':80' \\
                        '-d auth' \\
                        '--bind-tcp=0.0.0.0:8080,auth=password,value=\$GENERATE_PASS' \\
                        '--mdns=no' \\
                        '--webcam=no' \\
                        '--no-daemon' \\
                        '--notifications=no' \\
                        '--no-audio' \\
                        '--start-on-connect=/usr/bin/terminator' \\
                        '--start=xhost +'

    " ubuntu
sleep infinity
IS_A_ENTRYPOINT

chmod +x /usr/local/bin/xpra-entrypoint.sh
EOF


EXPOSE 8080

ENTRYPOINT [ "/usr/local/bin/xpra-entrypoint.sh" ]
