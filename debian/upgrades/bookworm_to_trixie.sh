#!/usr/bin/env bash

set -euo pipefail

main() {
    echo 'Upgrading from Debian 12 Bookworm to Debian 13 Trixie'
    echo '...'
    echo 'Run as root or stop this script now.'
    sleep 3
    echo 'Follow along for interactive promts!'
    for each_package in $(apt-mark showhold | more)
    do
        apt-mark unhold $each_package
    done
    apt update
    apt upgrade -y
    apt full-upgrade -y
    apt --purge autoremove -y
    sed -i 's/bookworm/trixie/g' /etc/apt/sources.list
    find /etc/apt/sources.list.d -type f -exec sed -i 's/bookworm/trixie/g' {} \;
    apt update
    apt upgrade -y
    apt full-upgrade -y
    apt autoremove -y
    echo 'Now reboot!'
    echo 'systemctl reboot'
}

main
