#!/usr/bin/env bash

set -euo pipefail

main() {
    echo '# Restarting the k8s cluster!'
    sudo swapoff -a
    rm -rf $HOME/.kube
    sudo kubeadm reset
    sudo rm -r /etc/cni/net.d
    echo '# I only had to run these once when debuggin the docker traffic was not flowing'
    echo '# In the end the issue was this other file called `cat /etc/sysctl.conf`'
    echo '# I had to uncomment the line that said #net.ipv4.ip_forward=1'
    sudo iptables -F
    sudo iptables -X
    sudo iptables -t nat -F
    sudo iptables -t nat -X
    sudo iptables -t raw -F
    sudo iptables -t raw -X
    sudo iptables -t mangle -F
    sudo iptables -t mangle -X
    sudo service docker restart
    sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-cert-extra-sans=r0m4n.com
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
    kubectl taint nodes --all node-role.kubernetes.io/master-
}

main
