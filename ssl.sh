#!/bin/bash

# SSL

sudo mkdir /etc/nginx/ssl

#openssl ca -batch -config "$CONF" -out "$BOXCERT" -infiles "$CSRFILE"

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/C=ES/ST=VALENCIA/L=VALENCIA/O=desarrolloactivo.com/OU=D.A./CN=desarrolloactivo.com/emailAddress=admin@desarrolloactivo.com"

# Country Name (2 letter code) [AU]:US
# State or Province Name (full name) [Some-State]:New York
# Locality Name (eg, city) []:New York City
# Organization Name (eg, company) [Internet Widgits Pty Ltd]:Bouncy Castles, Inc.
# Organizational Unit Name (eg, section) []:Ministry of Water Slides
# Common Name (e.g. server FQDN or YOUR name) []:your_domain.com
# Email Address []:admin@your_domain.com