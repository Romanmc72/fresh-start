#!/usr/bin/env bash

set -euo pipefail

export MINECRAFT_ROOT='/media/drive/minecraft'

main() {
    echo_help() {
        echo '| upgrade_server.sh( $1 )'
        echo '+=================================================================='
        echo '| Description'
        echo '| -----------'
        echo '| Run this script and point it at the root of where your minecraft'
        echo '| spigot server will run. It will install the latest spigot server,'
        echo '| build that server file, and also install the geyser and flodgate'
        echo '| plugins.'
        echo '|'
        echo '| Params'
        echo '| ------'
        echo '| $1 :MINECRAFT_ROOT: string'
        echo '| The root location of the minecraft server in your filesystem.'
        echo '| This script expects unix like file paths not windows.'
        echo '|'
        echo '| $2 :MINECRAFT_VERSION: string [default:null]'
        echo '| The specific minecraft server version to build. If not specified,'
        echo '| the latest build tools build will be used with whatever its'
        echo '| default happens to be.'
        echo '|'
        echo '| Help'
        echo '| ----'
        echo '| Pass in either the incorrect number of arguments or one of the'
        echo '| "help flags" to see this message and exit the script.'
        echo '|'
        echo '| "help flags" = --help | -h | help | h'
        echo '|'
    }
    case "$#" in
        "1" )
            case "$1" in
                "h"|"help"|"-h"|"--help" )
                    echo_help
                    return 1
                    ;;
                * )
                    MINECRAFT_ROOT="$1"
                    ;;
            esac
            ;;
        * )
            echo_help
            return 1
            ;;
    esac
    echo 'Moving old server'
    mv spigot-server.jar old-spigot-server.jar || echo 'Old server not found, continuing...'

    echo 'Downloading Build Server'
    wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastStableBuild/artifact/target/BuildTools.jar \
        -O "${MINECRAFT_ROOT}/buildserver.jar" && \
        echo '#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).' > "${MINECRAFT_ROOT}/eula.txt" && \
        echo "#$(date)" >> "${MINECRAFT_ROOT}/eula.txt" && \
        echo 'eula=true' >> "${MINECRAFT_ROOT}/eula.txt"

    mkdir -p "${MINECRAFT_ROOT}/plugins"

    echo 'Downloading Geyser Plugin'
    wget https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot -O "${MINECRAFT_ROOT}/plugins/Geyser-Spigot.jar"

    echo 'Downloading Floodgate Plugin'
    wget https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot -O "${MINECRAFT_ROOT}/plugins/floodgate-spigot.jar"


    echo 'Building Spigot Server'
    case "$#" in
        "2" )
            echo "Building using version '$2'"
            java -jar "${MINECRAFT_ROOT}/buildserver.jar" --rev "$2"
            ;;
        * )
            echo 'Building using default version'
            java -jar "${MINECRAFT_ROOT}/buildserver.jar"
            ;;
    esac

    echo 'Replace Server'
    mv spigot-1*.jar spigot-server.jar

    echo 'Done!'
}

main "$@"

