#!/bin/bash

# OBTENEMOS EL NOMBRE DEL SCRIPT
nombre_script=$(basename "$0")

# COMPROBACIÓN DE USUARIO
if [ "$(id -u)" != "0" ]; then
    echo "Por favor, ejecuta este script con sudo."
    exit 1
fi

# OBTENEMOS EL DIRECTORIO ACTUAL
directorio_instalacion=$(pwd)

# ACTUALIZAMOS Y UPGRADEAMOS EL SISTEMA
realizar_full_upgrade() {
    sudo apt update && sudo apt full-upgrade -y
    echo "Full-upgrade completado."
}

while true; do
    read -p "¿Deseas realizar un 'apt update' en el sistema? (SI/NO): " respuesta_update
    respuesta_update=$(echo "$respuesta_update" | tr '[:upper:]' '[:lower:]')

    if [ "$respuesta_update" = "si" ]; then
        sudo apt update
        echo "'apt update' completado."
        break
    elif [ "$respuesta_update" = "no" ]; then
        echo "Operación 'apt update' cancelada."
        break
    else
        echo "Respuesta no válida. Por favor, responde 'SI' o 'NO'."
    fi
done

while true; do
    read -p "¿Deseas realizar un 'full-upgrade' en el sistema? (SI/NO): " respuesta_upgrade
    respuesta_upgrade=$(echo "$respuesta_upgrade" | tr '[:upper:]' '[:lower:]')

    if [ "$respuesta_upgrade" = "si" ]; then
        realizar_full_upgrade
        break
    elif [ "$respuesta_upgrade" = "no" ]; then
        echo "Operación 'full-upgrade' cancelada."
        break
    else
        echo "Respuesta no válida. Por favor, responde 'SI' o 'NO'."
    fi
done

# INSTALAMOS LAS DEPENDENCIAS NECESARIAS
sudo apt install imagemagick brightnessctl feh xclip bspwm sxhkd wmname polybar betterlockscreen bat lsd fzf flameshot picom rofi kitty zsh -y

# CONFIGURANDO FONTS
sudo cp -r fonts /usr/local/share

# CONFIGURANDO WALLPAPERS
cp -r Wallpapers ~/

# CONFIGURANDO BETTERLOCKSCREEN
betterlockscreen -u ~/Wallpapers

# CONFIGURANDO SXHKD
cp -r sxhkd ~/.config

# CONFIGURANDO KITTY
cp -r kitty ~/.config  

# CONFIGURANDO PICOM
cp -r picom ~/.config

# CONFIGURANDO PLUGIN SUDO ZSH
sudo cp -r zsh-sudo /usr/share

# CONFIGURANDO BSPWM
cp -r bspwm ~/.config 
cd ~/.config/bspwm 
chmod +x bspwmrc  
cd ~/.config/bspwm/scripts 
chmod +x * 
cd "$directorio_instalacion"

# CONFIGURANDO ROFI
cp -r rofi ~/.config  
cd ~/.config/rofi  
cd launcher  
chmod +x launcher.sh 
cd ../powermenu 
chmod +x powermenu.sh
cd "$directorio_instalacion"

# CONFIGURANDO POLYBAR
cp -r polybar ~/.config
cd ~/.config/polybar/scripts 
chmod +x *
mkdir ~/.config/bin     
touch ~/.config/bin/target
cd "$directorio_instalacion"

# CONFIGURANDO POWERLEVEL10K
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
mv zshrc .zshrc 
mv p10k.zsh .p10k.zsh   
cp .p10k.zsh ~/
cp .zshrc ~/ 

# CONFIGURANDO POWERLEVEL10K DE ROOT
sudo su
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
cp p10k.zsh_root /root
cp .zshrc /root
cd /root
mv p10k.zsh_root .p10k.zsh

# CREAMOS UN LINK SIMBÓLICO ENTRE LA ZSHRC DE NUESTRO USUARIO Y LA ZSHRC DE ROOT
sudo ln -s -f ~/.zshrc /root/.zshrc

# ELIMINAMOS EL DIRECTORIO DE INSTALACIÓN
sudo rm -rf "$directorio_instalacion"

# ELIMINAMOS LOS PAQUETES QUE NO SON NECESARIOS
sudo apt autoremove

# ELIMINAMOS LOS ARCHIVOS DE CACHÉ
sudo apt clean
