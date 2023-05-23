# Minecraft Server

This just contains a few helper scripts for launching a cross-platform minecraft server on Debian. The assumption here is that you already have run the appropriate `init.sh` script in the `../headless/` folder next to this one. There is an `init.sh` script here as well for the first time launch. Run that as root, and from then on you will need to run everything as the user `minecraft` (created during this init script).

## Running

The few scripts here are:

- `./init.sh` - Run when initializing a new system
- `./upgrade_server.sh` - Run when upgrading or initially installing the server
- `./start.sh` - Run to actually start the server

All of those scripts come with the ability to pass a `--help` flag. It is HIGHLY recommended that you run the `./start.sh` script using a `tmux` session instead of leaving an open terminal session going forever. That way you can ssh into and out of whatever box that this is running on. You do not have to do this, it is just highly recommended.
