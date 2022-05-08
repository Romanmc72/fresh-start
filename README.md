# Startup

This repository exists to make it easier for me to restart my systems or boot into new ones with a lot of the default settings already configured to my liking. I have started and restarted a few different debian servers in my personal at-home network, I have also created a debain desktop on an old macbook pro and most often I use a macbook pro at work with OSX installed. This repository contains several folders inside of each will be:

- `.(ba|z)shrc` script which I will utilize to set the default shell, variables, and aliases I want, and a 
- `init.sh` script which will be used to install all of the programs and utilities I want that are likely not already part of the base system

Other than that, I don't really have a ton else. There will likely be some shared code between a few of the different setups, so I might also include some kind of a common pre-step script for all scenarios.

## Before you start

First thing you will need to do is install `git` and clone this repo in order to actually have access to these scripts. Make sure you're logged in as root or have root privileges, then run:

```bash
# Installs git
ap-get install -y git

# clones the repo
git clone git@github.com:Romanmc72/startup
```

Then move to your desired directory and begin installing things for the target system!
