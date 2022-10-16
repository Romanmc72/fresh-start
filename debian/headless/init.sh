#!/usr/bin/env bash

set -euo pipefail

main() {
    echo 'Ensure you are running as root, if not abort and start over...'
    sleep 3
    apt update
    apt upgrade
    apt-get remove docker docker-engine docker.io containerd runc || echo 'Looks like it was not there'

    apt install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        jq \
        lsb-release \
        sudo \
        tree \
        tmux
    
    # Install docker & kubeadm
    # Last updated from web instructions as of 2022-05-08
    curl -fsSL https://download.docker.com/linux/debian/gpg | \
        gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    cat <<EOF | tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

    cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
    
    sysctl --system

    curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg \
        https://packages.cloud.google.com/apt/doc/apt-key.gpg
    
    echo \
        "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | \
        tee /etc/apt/sources.list.d/kubernetes.list

    apt-get update
    apt-get install -y \
        kubelet \
        kubeadm \
        kubectl \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-compose-plugin
    apt-mark hold kubelet kubeadm kubectl    

    groupadd docker || echo 'Group already exists...'
    usermod -aG docker roman
    chmod 666 /var/run/docker.sock
    echo '#includedir /etc/sudoers.d' >> /etc/sudoers
    echo 'roman ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
    echo 'Disabling swap to allow joining the k8s cluster.'
    echo 'Re-enable if you want using:'
    echo ''
    echo 'sudo swapon -a'
    echo ''
    swapoff -a
    echo 'Make sure you log into Docker:'
    echo '`docker login`'
    echo 'Also update the /etc/sysctl.conf file for the line with:'
    echo 'Uncomment this line'
    echo 'net.ipv4.ip_forward=1'
}

main
