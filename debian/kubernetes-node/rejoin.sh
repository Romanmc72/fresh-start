#!/usr/bin/env bash

set -euo pipefail 

main() {
    echo 'Run the commands to remove the node in remove-node.sh'
    echo 'Then...'
    echo '================================================'
    echo '# On the control plane / master node run:'
    echo 'sudo kubeadm token create --print-join-command'
    echo 'exit'
    echo '================================================'
    echo '# Copy the above generated join command and run'
    echo '# it on your worker node as root after it has been'
    echo '# configured successfully with the init.sh script'
    echo 'sudo kubeadm join <whatever that join command above was>'

}

main
