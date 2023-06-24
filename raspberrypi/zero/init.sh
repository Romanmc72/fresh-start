#!/usr/bin/env sh

set -euo pipefail

main() {
    echo 'Ensure this is running as root, otherwise start the script over and run with sudo'
    sleep 2
    echo '...'
    sleep 2
    echo '...'
    sleep 1
    echo 'Running initial setup!'
    apt update
    apt upgrade -y
    apt install -y\
        python3-pip \
        python3-smbus \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        jq \
        lsb-release \
        sudo \
        tree \
        tmux
    pip3 install \
        gpiozero \
        RPi.GPIO \
        RPLCD
    echo 'Installed some CLI tools and some GPIO Python packages'
    echo 'Various applications may require additional installation, read the READMEs!'
    echo 'Done!'
}

main
