#!/bin/bash

# This script automatically and seemlessly installs Processing, a desktop environment, 
# and KasmVNC to allow the end user to access the server under a browser-based VNC client.


# Change these variables to change the version of Processing or KasmVNC installed.
# The version chosen is particularly significant! As of writing (1/15/2025), 
# GitHub Codespaces uses Ubuntu 20.04 LTS (Focal Fossa, or just Focal).

# Try your best to keep this URL up to date.
# Generally speaking, leaving the version slightly outdated is (most of the time) OK.
PROCESSING_URL="https://github.com/processing/processing4/releases/download/processing-1295-4.3.2/processing-4.3.2-linux-x64.tgz"
# Always use the .deb file with 'focal' in it (match the system's Ubuntu version)!
KASM_URL="https://github.com/kasmtech/KasmVNC/releases/download/v1.3.2/kasmvncserver_focal_1.3.2_amd64.deb"


# Change the default login credentials for KasmVNC.
# This will not affect the codespace user's login credentials at all!

USERNAME="user"
PASSWORD="password"

# Although not particularly "ideal", keeping these credentials as-is
# is perfectly safe, as forwarded ports are kept private by default and
# inaccessible to the general Internet.

SCRIPT_DIR=$(realpath $(dirname "$0"))

if [ -z "${CODESPACES}" ]; then
    echo "You are not in a GitHub codespace."
fi

if [ ! -e ~/.setup ]; then
    echo "This script will set up Processing, and will provide you a way to access your codespace's desktop environment."
    echo "Press enter to continue, or Ctrl + C to exit now. This will take a few minutes to complete, but further startups will be much more faster."
    read

    # we don't want people to sigint out while the script is running
    trap '' SIGINT

    echo "Updating your system, please wait..."
    export DEBIAN_FRONTEND=noninteractive
    sudo apt update -y
    sudo apt upgrade -y

    echo "Installing desktop environment and Processing, please wait..."
    sudo bash -c "DEBIAN_FRONTEND=noninteractive apt install xfce4 xdg-utils -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confdef" </dev/null"
    sudo apt install firefox -y

    if [ -d "/tmp/processing" ]; then
        rm -rf /tmp/processing
    fi

    mkdir /tmp/processing
    cd /tmp/processing 
    wget $PROCESSING_URL -O /tmp/processing/processing.tar.gz

    mkdir -p ~/processing
    tar -xf /tmp/processing/processing.tar.gz -C ~/processing
    cd ~/processing/*
    ./install.sh

    echo "Setting up desktop..."
    if [ ! -d ~/Desktop ]; then
        mkdir ~/Desktop
    fi
    ln -s ~/.local/share/applications/processing-pde.desktop ~/Desktop/processing-pde.desktop
    chmod +x ~/Desktop/processing-pde.desktop
    ln -s $SCRIPT_DIR ~/Desktop/Your\ Code

    sed -i '1i#!/bin/sh' ~/Desktop/.savecode.sh
    echo -e "cd ~/Desktop/Your\ Code\ngit add .\ngit commit -m 'Manual code commit'\ngit push\necho 'Your code was successfully uploaded and saved.'\nread" > ~/Desktop/.savecode.sh
    chmod +x ~/Desktop/.savecode.sh

    echo "[Desktop Entry]
Version=1.0
Type=Application
Name=Save Your Code
Comment=
Exec=/bin/bash $HOME/Desktop/.savecode.sh
Icon=system-upgrade
Path=$HOME/Desktop
Terminal=true
StartupNotify=false" > $HOME/Desktop/Save\ Your\ Code.desktop
    chmod +x $HOME/Desktop/Save\ Your\ Code.desktop

    echo "Installing KasmVNC..."
    cd /tmp/processing
    wget $KASM_URL -O kasm.deb
    sudo apt install ./kasm.deb -y

    echo "Setting up KasmVNC..."
    echo -e "network:\n  ssl:\n    require_ssl: false\ncommand_line:\n    prompt: false\n$(cat /etc/kasmvnc/kasmvnc.yaml)" | sudo tee /etc/kasmvnc/kasmvnc.yaml > /dev/null
    sudo usermod -aG ssl-cert $USER

    script -q /dev/null bash -c "printf '%s\n%s\n' '$PASSWORD' '$PASSWORD' | vncpasswd -u $USERNAME -wo"

    if [ ! -d ~/.vnc ]; then
        mkdir ~/.vnc
    fi

    touch $HOME/.vnc/.de-was-selected
    echo "" > ~/.vnc/xstartup
    sed -i '1i#!/bin/sh' ~/.vnc/xstartup
    echo -e "set -x\nxdg-settings set default-web-browser firefox.desktop\n(sleep 2 && xdg-settings set default-web-browser firefox.desktop) &\nexec xfce4-session" >> ~/.vnc/xstartup  
    chmod +x ~/.vnc/xstartup

    cd $SCRIPT_DIR
    sg ssl-cert -c "vncserver :0 > /dev/null"

    echo "================"
    echo "VNC setup has completed! Follow the below steps to access the server. You will need to run this script EVERY TIME you enter this Codespace."
    echo "1. Press the command bar button at the very top of the page (it should say something like '[Codespaces: <name>]')"
    echo "2. Type '> Forward a Port', and click "Forward a Port". When prompted, provide the port number (8443)."
    echo "   - See 'Port is already forwarded'? Skip this step, and move on to Step 3."
    echo "3. A tab should pop up from the bottom of this code editor! Hover over the URL (the blue text), and press the little globe."
    echo "   - Be patient! It sometimes takes a little bit for the desktop (and server) to start up!"
    echo "   - Username: '$USERNAME'; password: '$PASSWORD'"
    echo "================"

    touch ~/.setup
    newgrp ssl-cert
else
    vncserver -kill :0 > /dev/null 2>&1
    vncserver :0 > /dev/null 2>&1
    echo "================"      
    echo "The VNC server is now running! Follow the below steps to access the server. You will need to run this script EVERY TIME you enter this Codespace."
    echo "1. Press the command bar button at the very top of the page (it should say something like '[Codespaces: <name>]')"
    echo "2. Type '> Forward a Port', and click "Forward a Port". When prompted, provide the port number (8443)."
    echo "   - See 'Port is already forwarded'? Skip this step, and move on to Step 3."
    echo "3. A tab should pop up from the bottom of this code editor! Hover over the URL (the blue text), and press the little globe."
    echo "   - Be patient! It sometimes takes a little bit for the desktop (and server) to start up!"
    echo "   - Username: '$USERNAME'; password: '$PASSWORD'"
    echo "================"
    echo "It seems as if you have already ran this setup script."
    echo "If something isn't working quite right, run 'rm -f ~/.setup', and try again to retry your VNC installation."
fi
trap - SIGINT






