#!/usr/bin/env bash

set -euo pipefail

main() {
    echo 'Commands to copy-paste to reset your worker node'
    echo '================================================'
    echo ''
    echo 'kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data --pod-selector=kube-system'
    echo 'sudo kubeadm reset'
    echo 'sudo rm -rf /etc/cni/net.d'
    echo 'rm -r ~/.kube'
    echo ''
    echo '######### RUN THIS BLOCK AS ROOT #########'
    echo 'iptables -F && iptables -X'
    echo 'iptables -t nat -F && iptables -t nat -X'
    echo 'iptables -t raw -F && iptables -t raw -X'
    echo 'iptables -t mangle -F && iptables -t mangle -X'
    echo '##########################################'
}

main
