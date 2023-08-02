#!/usr/bin/env bash

set -euo pipefail

main() {
    echo '# Restarting the k8s cluster!'
    ./common-reset.sh
    sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-cert-extra-sans=r0m4n.com
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
    kubectl taint nodes --all node-role.kubernetes.io/master-
}

main
