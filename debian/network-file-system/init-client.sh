#!/usr/bin/env bash

set -euo pipefail


echo-init-client-help() {
    echo '| ./init-client.sh $1 $2 $3'
    echo '+=================================================================='
    echo '| Description'
    echo '| -----------'
    echo '| Initializes the connection of one of the nfs clients to the nfs'
    echo '| server'
    echo '|'
    echo '| Params'
    echo '| ------'
    echo '| $1 : string : MOUNT_POINT'
    echo '| Where within the current file system to mount the nfs to'
    echo '|'
    echo '| $2 : string : NFS_IP_ADDRESS'
    echo '| The IP Address associated to the nfs'
    echo '|'
    echo '| $3 : string : NFS_MOUNTED_POINT'
    echo '| The location within the nfs where the directory is mounted'
    echo '| for sharing'
    echo '|'
}


main() {
    echo 'Ensure you are running as root!'
    case "$#" in
        "3" )
            case "$1" in
                "h" | "help" | "-h" | "--help" )
                echo-init-client-help
                return 1
                ;;
            esac
            MOUNT_POINT="$1"
            NFS_IP_ADDRESS="$2"
            NFS_MOUNTED_POINT="$3"
            ;;
        * )
            echo-init-client-help
            return 1
            ;;
    esac
    apt update
    apt upgrade -y
    apt install nfs-common -y
    mkdir -p "${MOUNT_POINT}"
    mount -t nfs "${NFS_IP_ADDRESS}:${NFS_MOUNTED_POINT}" $MOUNT_POINT
    echo 'Ensuring this remounts at reboot'
    MOUNT_CONFIG="${NFS_IP_ADDRESS}:${NFS_MOUNTED_POINT} ${MOUNT_POINT} nfs defaults 0 0"
    if [[ -z $(grep "$MOUNT_CONFIG" /etc/fstab) ]]
    then
        echo 'Setting up permanent remount'
        echo $MOUNT_CONFIG | tee -a /etc/fstab
    else
        echo 'Permanent remount already set up'
    fi
}

main $@
