# Reverse Proxy

These are the NGINX config files for the reverse proxy to run on one of my servers. Checking this into a repository should that server ever totally go down so that I can restart things on a different one with ease.

The `nginx.conf` goes in `/etc/nginx/nginx.conf` and the `r0m4n.com` goes in `/etc/nginx/sites-available/r0m4n.com` and then to actually enable it, create a symlink to the `/etc/nginx/sites-enabled/r0m4n.com` folder.

## Other things

Obviously nginx needs to be installed for this to work. So probably do that too.

```
sudo apt install nginx
```
