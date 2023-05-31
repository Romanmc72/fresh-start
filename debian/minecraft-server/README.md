# Minecraft Server

This just contains a few helper scripts for launching a cross-platform minecraft server on Debian. The assumption here is that you already have run the appropriate `init.sh` script in the `../headless/` folder next to this one. There is an `init.sh` script here as well for the first time launch. Run that as root, and from then on you will need to run everything as the user `minecraft` (created during this init script).

## Running

The few scripts here are:

- `./init.sh` - Run when initializing a new system
- `./upgrade_server.sh` - Run when upgrading or initially installing the server
- `./start.sh` - Run to actually start the server
- `./cron_job_upgrade.sh` - Run this via cron (with some edits) to auto-upgrade the server on some cadence

All of those scripts come with the ability to pass a `--help` flag. It is HIGHLY recommended that you run the `./start.sh` script using a `tmux` session instead of leaving an open terminal session going forever. That way you can ssh into and out of whatever box that this is running on. You do not have to do this, it is just highly recommended.

### Cron config

I ran `crontab -e` as root to set up a root cron job using the `cron_job_upgrade.sh` script. My script runs from the git repo where my current user is located so it looks like this when I set it up for the root user:

```
0 3 * * 3 /home/roman/git/fresh-start/debian/minecraft-server/cron_job_upgrade.sh
```

This should set it up to upgrade the server every week at 3:00 AM server time on Wednesdays.
