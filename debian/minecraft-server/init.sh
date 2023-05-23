#!/usr/bin/env bash

set -euo pipefail

main() {
    echo 'Ensure that you are running this as root, otherwise cancel and restart...'
    sleep 5
    apt update
    apt upgrade -y
    echo 'Installing java and other dependencies'
    apt install wget git tmux openjdk-17-jdk openjdk-17-jre -y
    echo 'Setting up the minecraft user...'
    groupadd minecraft || echo 'WARN: minecraft group may already exist... continuing'
    useradd -g minecraft minecraft || echo 'WARN: minecraft user may already exist... continuing'
    mkdir -p /home/minecraft
    chown -R minecraft:minecraft /home/minecraft
    chsh minecraft -s /usr/bin/bash
    echo 'Done!'
}

main
