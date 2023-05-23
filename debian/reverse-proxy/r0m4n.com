##
# You should look at the following URL's in order to grasp a solid understanding
# of Nginx configuration files in order to fully unleash the power of Nginx.
# https://www.nginx.com/resources/wiki/start/
# https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/
# https://wiki.debian.org/Nginx/DirectoryStructure
#
# In most cases, administrators will remove this file from sites-enabled/ and
# leave it as reference inside of sites-available where it will continue to be
# updated by the nginx packaging team.
#
# This file will automatically load configuration files provided by other
# applications, such as Drupal or Wordpress. These applications will be made
# available underneath a path with that package name, such as /drupal8.
#
# Please see /usr/share/doc/nginx-doc/examples/ for more detailed examples.
##

# Default server configuration
##

# Passes DNS info to the PI Hole DNS Server

server {
	listen 80;
	listen 443;
	server_name pihole.r0m4n.com;
	location / {
		proxy_pass http://0.0.0.0:30661;
	}
} 


server {
	listen 80 default_server;
	server_name *.r0m4n.com;
	return 301 https://$host$request_uri;
}


server {
	listen 80;
	listen 443;
	server_name delltower.local;
	location / {
		proxy_pass http://0.0.0.0:31275;
	}
}

server {
	listen 80;
	listen 443;
	server_name 192.168.0.19;
	location / {
		proxy_pass http://0.0.0.0:31275;
	}
}

server {
	listen [::]:443 ssl;
	listen 443 ssl default_server;
    ssl_certificate /etc/letsencrypt/live/r0m4n.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/r0m4n.com/privkey.pem; # managed by Certbot
	server_name r0m4n.com;
	location / {
		proxy_pass http://0.0.0.0:31275;
	}

}

server {
	listen [::]:443;
        listen 443 ssl;
    ssl_certificate /etc/letsencrypt/live/r0m4n.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/r0m4n.com/privkey.pem; # managed by Certbot
        server_name scoreboard.r0m4n.com;
	location / {
                proxy_pass http://0.0.0.0:30916;
        }

}

