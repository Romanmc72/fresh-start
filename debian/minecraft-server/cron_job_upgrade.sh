#!/usr/bin/env bash

set -euo pipefail

get_tmux_send_keys() {
    keys="$1"
    echo -n "tmux send-keys -t minecraft-server '${keys}' Enter"
}

main() {
    echo_help() {
        echo '| cron_job_upgrade.sh()'
        echo '+=================================================================='
        echo '| Description'
        echo '| -----------'
        echo '| Schedule this to run via a cron job nightly at some point so that'
        echo '| the minecraft server will auto-upgrade. This must be run as root'
        echo '| and the minecraft user cannot have a password (or maybe they can?'
        echo '| idk mine does not).'
        echo '|'
        echo '| There are some hard coded settings in here at the moment. If you'
        echo '| use a different minecraft server root location and a different'
        echo '| amount of GB to run your server then fo sho edit this script.'
        echo '|'
        echo '| Mine runs from /media/drive/minecraft at 32 GB'
        echo '|'
        echo '| Params'
        echo '| ------'
        echo '| None! There are no params. If you pass one in (no matter what it is)'
        echo '| this help will show.'
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
            echo_help
            return 1
            ;;
        * )
            echo '+===================================================+'
            echo '| Upgrading the Minecraft Server in the background! |'
            echo '+===================================================+'
            ;;
    esac
    echo 'Sending a 1 minute shutdown warning to any players on the server'
    su -c "$(get_tmux_send_keys 'say Shutting down the server in 1 minute!!!')" - minecraft
    echo 'They have been warned'
    sleep 60
    su -c "$(get_tmux_send_keys 'say Shutting down the server now!!!')" - minecraft
    echo 'Stopping the current server...'
    su -c "$(get_tmux_send_keys stop)" - minecraft
    echo 'Stop command has been sent, waiting 5 minutes...'
    sleep 300
    echo 'Running upgrade commands now!'
    su -c './upgrade_server.sh /media/drive/minecraft' - minecraft
    echo 'Waiting for 15 minutes while upgrade runs...'
    sleep 900
    echo 'Restarting the server...'
    su -c "$(get_tmux_send_keys './start.sh 32')" - minecraft
    echo 'Waiting for 5 minutes then will check to see if server is running...'
    sleep 300
    echo 'Checking to see if server is running...'
    if [[ -z $(pgrep -u minecraft java) ]]
    then
        echo '+!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!+'
        echo '| Looks like it is not running :( go check out what went wrong |'
        echo '+!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!+'
        return 1
    else
        echo 'Server appears to be up! Have fun at the latest minecraft server'
    fi
    echo '+===========================+'
    echo '| Done with server upgrade. |'
    echo '+===========================+'
}

main "$@"
