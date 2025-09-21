#!/bin/bash

# Script completo para setup Wayland no Ubuntu Server
set -e

echo "🚀 Configurando Wayland no Ubuntu Server..."

# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Pacotes base para Wayland
sudo apt install -y \
    wayland-compositor-libs \
    xwayland \
    pipewire-pulse \
    wireplumber \
    xdg-desktop-portal-gtk \
    xdg-desktop-portal-wlr

# LabWC (Compositor leve)
echo "📦 Instalando LabWC..."
sudo apt install -y \
    labwc \
    openbox \
    obconf \
    wofi \
    waybar \
    mako-notifier \
    grim \
    slurp \
    wl-clipboard \
    brightnessctl \
    playerctl \
    wlr-randr \
    swaylock \
    network-manager-gnome

# Sway (Compositor tiling)
echo "📦 Instalando Sway..."
sudo apt install -y \
    sway \
    swaybg \
    swayidle \
    swaylock

# Aplicações essenciais
sudo apt install -y \
    terminator \
    firefox \
    caja \
    mate-desktop-environment-core \
    pavucontrol

# Criar diretórios de configuração
mkdir -p ~/.config/{labwc,sway,waybar,mako,wofi}

# Configurar LabWC
echo "⚙️  Configurando LabWC..."
cp /etc/xdg/openbox/menu.xml ~/.config/labwc/menu.xml

cat > ~/.config/labwc/rc.xml << 'EOF'
<?xml version="1.0"?>
<labwc_config>
  <theme>
    <name>Clearlooks</name>
  </theme>
  <keyboard>
    <keybind key="Super_L">
      <action name="Execute" command="wofi --show drun" />
    </keybind>
    <keybind key="A-F4">
      <action name="Close" />
    </keybind>
    <keybind key="A-Tab">
      <action name="NextWindow" />
    </keybind>
    <keybind key="Print">
      <action name="Execute" command="grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png" />
    </keybind>
  </keyboard>
</labwc_config>
EOF

# Configurar Sway
echo "⚙️  Configurando Sway..."
if [ ! -f ~/.config/sway/config ]; then
    sudo cp /etc/sway/config ~/.config/sway/ 2>/dev/null || cp /usr/share/sway/config ~/.config/sway/
fi

# Adicionar configurações customizadas ao Sway
cat >> ~/.config/sway/config << 'EOF'

# Configurações customizadas
exec mako
exec nm-applet --indicator
exec waybar

# Wallpaper
output * bg /usr/share/backgrounds/warty-final-ubuntu.png fill

# Keybindings customizados
bindsym $mod+Shift+e exec swaynag -t warning -f "Noto Sans 11" --text "#FFFFFF" --button-text "#FFFFFF" -m 'Power Menu Options' -b 'Logout' 'swaymsg exit' -b 'Restart' 'shutdown -r now' -b 'Shutdown' 'shutdown now' --background "#108500" --button-background "#104090"
bindsym --release Super_L exec wofi -i -I -a --show="drun,run" -W 640 -H 480
bindsym ctrl+mod1+t exec terminator
bindsym $mod+l exec swaylock -c 000000
bindsym Print exec grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png
bindsym Shift+Print exec grim -g "$(slurp)" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png

# Tema e gaps
client.focused          #315B32 #315B32 #ffffff
client.unfocused        #00000050 #00000050 #ffffff00
default_border none
default_floating_border none
gaps inner 10

# Teclado brasileiro
input type:keyboard {
  xkb_layout "br"
  xkb_variant "abnt2"
}

# Controles de mídia
bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
bindsym XF86MonBrightnessUp exec brightnessctl set +1%
bindsym XF86MonBrightnessDown exec brightnessctl set 1%-
EOF

# Configurar Waybar
echo "⚙️  Configurando Waybar..."
cat > ~/.config/waybar/config << 'EOF'
{
    "layer": "top",
    "position": "top",
    "height": 30,
    "modules-left": ["sway/workspaces", "sway/mode"],
    "modules-center": ["clock"],
    "modules-right": ["pulseaudio", "network", "battery", "tray"],
    
    "clock": {
        "format": "{:%a, %d %b %Y - %H:%M}",
        "tooltip": false
    },
    
    "battery": {
        "format": "{capacity}% {icon}",
        "format-icons": ["", "", "", "", ""],
        "states": {
            "warning": 30,
            "critical": 15
        }
    },
    
    "network": {
        "format-wifi": "{essid} ({signalStrength}%) ",
        "format-ethernet": "{ifname}: {ipaddr}/{cidr} ",
        "format-disconnected": "Desconectado ⚠",
        "tooltip": false
    },
    
    "pulseaudio": {
        "format": "{volume}% {icon}",
        "format-muted": "",
        "format-icons": ["", "", ""],
        "on-click": "pavucontrol"
    },
    
    "sway/workspaces": {
        "disable-scroll": true,
        "all-outputs": true
    }
}
EOF

# Configurar Mako (notificações)
cat > ~/.config/mako/config << 'EOF'
font=Ubuntu 10
background-color=#2d3748
text-color=#ffffff
border-color=#4a5568
border-radius=5
border-size=2
default-timeout=5000
EOF

# Configurar Wofi (launcher)
cat > ~/.config/wofi/style.css << 'EOF'
window {
    margin: 0px;
    border: 1px solid #4a5568;
    border-radius: 5px;
    background-color: #2d3748;
}

#input {
    margin: 5px;
    border: none;
    color: #ffffff;
    background-color: #4a5568;
    border-radius: 3px;
}

#inner-box {
    margin: 5px;
    color: #ffffff;
    background-color: transparent;
}

#outer-box {
    margin: 5px;
    background-color: transparent;
}

#scroll {
    margin: 0px;
    background-color: transparent;
}

#text {
    margin: 5px;
    color: #ffffff;
}

#entry:selected {
    background-color: #4a5568;
    border-radius: 3px;
}
EOF

# Criar diretório para screenshots
mkdir -p ~/Pictures

# Instalar Distrobox
echo "📦 Instalando Distrobox..."
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --prefix ~/.local

# Configurar variáveis de ambiente para Wayland
cat >> ~/.bashrc << 'EOF'

# Configurações Wayland
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export WAYLAND_DISPLAY="wayland-1"
export QT_QPA_PLATFORM="wayland;xcb"
export GDK_BACKEND="wayland,x11"
export MOZ_ENABLE_WAYLAND=1
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
EOF

# Criar script de inicialização
cat > ~/.local/bin/start-wayland << 'EOF'
#!/bin/bash

# Escolha o compositor
echo "Escolha o compositor Wayland:"
echo "1) Sway (Tiling)"
echo "2) LabWC (Stacking/Floating)"
read -p "Opção [1-2]: " choice

case $choice in
    1)
        echo "Iniciando Sway..."
        exec sway
        ;;
    2)
        echo "Iniciando LabWC..."
        exec labwc
        ;;
    *)
        echo "Opção inválida. Iniciando Sway por padrão..."
        exec sway
        ;;
esac
EOF

chmod +x ~/.local/bin/start-wayland

echo "✅ Configuração concluída!"
echo ""
echo "Para iniciar o Wayland:"
echo "  ~/.local/bin/start-wayland"
echo ""
echo "Para usar com Distrobox:"
echo "  distrobox create --name ubuntu --image ubuntu:22.04"
echo "  distrobox enter ubuntu"
echo ""
echo "Aplicações instaladas:"
echo "  - Sway (compositor tiling)"
echo "  - LabWC (compositor stacking)"
echo "  - Waybar (barra de status)"
echo "  - Wofi (launcher de aplicações)"
echo "  - Mako (notificações)"
echo "  - Firefox, Terminator, Caja"
echo ""
echo "Atalhos importantes:"
echo "  Super: Abrir launcher"
echo "  Alt+F4: Fechar janela"
echo "  Alt+Tab: Alternar janelas"
echo "  Print: Screenshot"
echo "  Super+L: Bloquear tela (Sway)"
