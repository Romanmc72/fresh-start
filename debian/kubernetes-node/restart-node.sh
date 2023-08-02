#!/usr/bin/env bash

set -euo pipefail


echo-restart-node-help() {
    echo '| ./restart-node.sh $1 $2 $3'
    echo '+=================================================================='
    echo '| Description'
    echo '| -----------'
    echo '| Restarts a child node in the cluster, just pass in the join token'
    echo '|'
    echo '| Params'
    echo '| ------'
    echo '| $1 : string : IP_AND_PORT'
    echo '| The IP and port of the parent node to join'
    echo '|'
    echo '| $2 : string : TOKEN'
    echo '| The kubeadm join token to use to join the cluster'
    echo '|'
    echo '| $3 : string : DISCOVERY_CA_CERT_HASH'
    echo '| The discovery cert hash for the join command'
    echo '|'
}


main() {
    case "$#" in
        "3" )
            case "$1" in
                'h' | 'help' | '-h' | '--help' )
                    echo-restart-node-help
                    return 1
                    ;;
            esac
            ;;
        * )
            echo-restart-node-help
            return 1
            ;;
    esac
    IP_AND_PORT="$1"
    TOKEN="$2"
    DISCOVERY_CA_CERT_HASH="$3"
    ./common-reset.sh
    sudo kubeadm join \
        "${IP_AND_PORT}" \
        --token "${TOKEN}" \
        --discovery-token-ca-cert-hash "${DISCOVERY_CA_CERT_HASH}"
}

main $@
