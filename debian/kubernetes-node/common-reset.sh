#!/usr/bin/env bash
# Common reset commands whether you're a parent or a child node

set -euo pipefail

main() {
    sudo swapoff -a
    rm -rf $HOME/.kube
    sudo kubeadm reset --force
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
}

main $@
