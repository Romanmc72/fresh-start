#!/usr/bin/env bash

set -euo pipefail

main() {
  echo_help() {
    echo '| start.sh( $1 )'
    echo '+=================================================================='
    echo '| Description'
    echo '| -----------'
    echo '| Run this script at the root of your minecraft server and tell it'
    echo '| how many gigabytes to dedicate to running the server. Your server'
    echo '| needs to also be named `./spigot-server.jar` otherwise you can'
    echo '| edit this script below to point to your actual spigot server file.'
    echo '|'
    echo '| Params'
    echo '| ------'
    echo '| $1 :GIGABYTES: string'
    echo '| How many gigabytes to start dedicating that memory to the server.'
    echo '| Ensure that the number does not exceed the system'"'"'s available RAM.'
    echo '| It is always good to leave a little bit of extra RAM for the system'
    echo '| to operate. (Think 1 GB minimum for the system) That is assuming.'
    echo '| This is the only thing your server is actually running. If your'
    echo '| system is running mutliple applications then you are probably'
    echo '| advanced enough to figure out what the settings here should'
    echo '| be and stopped reading this message a while ago.'
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
          GIGABYTES="$1"
          ;;
      esac
      ;;
    * )
      echo_help
      return 1
      ;;
  esac

  echo 'Starting the Server!'
  java \
    "-Xmx$(($GIGABYTES*1024))M" \
    "-Xms$(($GIGABYTES*1024))M" \
    -XX:+UseG1GC -jar \
    ./spigot-server.jar \
    nogui
}

main "$@"

