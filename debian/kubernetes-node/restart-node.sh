#!/usr/bin/env bash

set -euo pipefail


echo-restart-node-help() {
    echo '| ./restart-node.sh $1'
    echo '+=================================================================='
    echo '| Description'
    echo '| -----------'
    echo '| Restarts a child node in the cluster, just pass in the join token'
    echo '|'
    echo '| Params'
    echo '| ------'
    echo '| $1 : string : JOIN_TOKEN'
    echo '| The kubeadm join token to use to join the cluster'
    echo '|'
}


main() {
    case "$#" in
        "$1" )
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
    sudo swapoff -a
    sudo kubeadm reset
    sudo rm -r /etc/cni/net.d
    sudo kubeadm join $@
}

main $@
