#!/usr/bin/env bash

set -euo pipefail

main() {
    echo '# Run these to restart the k8s cluster'
    echo ''
    echo 'sudo swapoff -a'
    echo 'rm -r ~/.kube'
    echo 'sudo kubeadm reset'
    echo 'sudo rm -r /etc/cni/net.d'
    echo '# I only had to run these once when debuggin the docker traffic was not flowing'
    echo '# In the end the issue was this other file called `cat /etc/sysctl.conf`'
    echo '# I had to uncomment the line that said #net.ipv4.ip_forward=1'
    echo '# sudo iptables -F'
    echo '# sudo iptables -t nat -F'
    echo '# sudo iptables -t mangle -F'
    echo '# sudo iptables -X'
    echo '# sudo iptables -L'
    echo '# sudo service docker restart'
    echo 'sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-cert-extra-sans=r0m4n.com'
    echo 'mkdir -p $HOME/.kube'
    echo 'sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config'
    echo 'sudo chown $(id -u):$(id -g) $HOME/.kube/config'
    echo 'sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config'
    echo '# If the lcoal one does not work anymore then below is the remote one, but it can change'
    echo 'kubectl apply -f restarts/kube-flannel.yml'
    echo '# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml'
    echo 'kubectl taint nodes --all node-role.kubernetes.io/master-'
    echo ''
    echo '# Now apply the helm charts...'
    echo '# Now you will need to get the PORT# that the service is running on so you can route NGINX to the correct proxypass, then run'
    echo 'sudo systemctl restart nginx'
    echo '# get the services port'
}

main
