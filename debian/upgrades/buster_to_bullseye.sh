#!/usr/bin/env bash

set -euo pipefail

main() {
    echo 'BUSTER IS IN THE ARCHIVES NOW! SAVE THE SOURCES LIST THEN MANUALLY '
    echo 'UPDATE TO LATEST BUSTER USING THE `archives.debian.org` NOT `{security,deb}.debian.org`'
    echo '...'
    echo 'Upgrading from Debian 10 Buster to Debian 11 Bullseye'
    echo '...'
    echo 'Run as root or stop this script now.'
    sleep 5
    echo 'Follow along for interactive promts!'
    for each_package in $(apt-mark showhold | more)
    do
        apt-mark unhold $each_package
    done
    apt update
    apt upgrade -y
    apt full-upgrade -y
    apt --purge autoremove -y
    sed -i 's/buster/bullseye/g' /etc/apt/sources.list
    sed -i 's/buster/bullseye/g' /etc/apt/sources.list.d/*.list
    sed -i 's#/debian-security bullseye/updates# bullseye-security#g' /etc/apt/sources.list
    apt update
    apt upgrade -y
    apt full-upgrade -y
    apt autoremove -y
    echo 'Now reboot!'
    echo 'systemctl reboot'
}

main
