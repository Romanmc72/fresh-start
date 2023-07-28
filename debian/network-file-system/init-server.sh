#!/usr/bin/env bash

set -euo pipefail

export DEFAULT_CIDR_RANGE='192.168.0.0/24'


echo-init-server-help() {
    echo '| ./init-server.sh $1 $2?'
    echo '+=================================================================='
    echo '| Description'
    echo '| -----------'
    echo '| Set up the nfs on the server side so that clients can connect to it'
    echo '|'
    echo '| Params'
    echo '| ------'
    echo '| $1 : string : MOUNT_POINT'
    echo '| Where within the file system to mount the nfs'
    echo '|'
    echo "| \$2 : string : CIDR_RANGE : default = ${DEFAULT_CIDR_RANGE}"
    echo '| Either an IPv4 CIDR range or an individual IP address to grant'
    echo '|access to the NFS'
    echo '|'
}


main() {
    echo 'Ensure you are running this under the root user!'
    case "$@" in 
        "1" )
            case "$1" in
                "h" | "help" | "-h" | "--help" )
                    echo-init-server-help
                    return 1
                    ;;
            esac
            MOUNT_POINT="$1"
            CIDR_RANGE="${DEFAULT_CIDR_RANGE}"
            ;;
        "2" )
            case "$1" in
                "h" | "help" | "-h" | "--help" )
                    echo-init-server-help
                    return 1
                    ;;
            esac
            MOUNT_POINT="$1"
            CIDR_RANGE="$2"
            ;;

        * )
            echo-init-server-help
            return 1
            ;;
    esac
    apt update
    apt upgrade -y
    apt install nfs-kernel-server -y
    mkdir -p $MOUNT_POINT
    chown -R nobody:nogroup $MOUNT_POINT
    chmod 777 $MOUNT_POINT
    ./add-ip-to-share.sh "${MOUNT_POINT}" "${CIDR_RANGE}"
    exportfs -a
    systemctl enable nfs-kernel-server 
    systemctl start nfs-kernel-server 
}

main $@
