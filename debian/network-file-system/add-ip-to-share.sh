#!/usr/bin/env bash

set -eou pipefail

export DEFAULT_ACCESS_LEVEL='(rw,sync,no_subtree_check)'


echo-add-ip-to-share-help() {
    echo '| ./add-ip-to-share.sh $1 $2 $3?'
    echo '+=================================================================='
    echo '| Description'
    echo '| -----------'
    echo '| Add access to the NFS mount point to a particular IP address at'
    echo '| a particular access level.'
    echo '|'
    echo '| Params'
    echo '| ------'
    echo '| $1 : string : MOUNT_POINT'
    echo '| The location of the NFS mount point to share'
    echo '|'
    echo '| $2 : string : IP_ADDRESS'
    echo '| Either the individual IP address or the CIDR range to add to the '
    echo '| list of allowed IPs that can access the NFS mount'
    echo '|'
    echo "| \$3 : string : ACCESS_LEVEL : default = ${DEFAULT_ACCESS_LEVEL}"
    echo '| The level of access to grant to the IP at the mount point. If not'
    echo '| specified it will set the default.'
    echo '|'
}


main() {
    case "$#" in
        "2" )
            case "$1" in
                "h" | "help" | "-h" | "--help" )
                    echo-add-ip-to-share-help
                    return 1
                    ;;
            esac
            MOUNT_POINT="$1"
            IP_ADDRESS="$2"
            ACCESS_LEVEL="${DEFAULT_ACCESS_LEVEL}"
            ;;
        "3" )
            MOUNT_POINT="$1"
            IP_ADDRESS="$2"
            ACCESS_LEVEL="$3"
            ;;
        * )
            echo-add-ip-to-share-help
            return 1
            ;;
    esac
    LINE_TO_ADD="${MOUNT_POINT} ${IP_ADDRESS}${ACCESS_LEVEL}" >> /etc/exports
    if [[ -z $(grep "$LINE_TO_ADD" /etc/exports) ]]
    then
        echo "Adding ${IP_ADDRESS} to ${ACCESS_LEVEL} at ${MOUNT_POINT}"
        echo $LINE_TO_ADD | tee -a /etc/exports
    else
        echo 'That access is already granted!'
    fi
}

main $@
