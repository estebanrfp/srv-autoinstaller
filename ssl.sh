#!/bin/bash

# SSL

sudo mkdir /etc/nginx/ssl

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/temp-nginx.crt -subj "/C=ES/ST=VALENCIA/L=VALENCIA/O=desarrolloactivo.com/OU=D.A./CN=desarrolloactivo.com/emailAddress=admin@desarrolloactivo.com"

sudo openssl req -new -key /etc/nginx/ssl/nginx.key -out nginx.csr -subj "/C=ES/ST=VALENCIA/L=VALENCIA/O=desarrolloactivo.com/OU=D.A./CN=desarrolloactivo.com/emailAddress=admin@desarrolloactivo.com"

# Country Name (2 letter code) [AU]:US
# State or Province Name (full name) [Some-State]:New York
# Locality Name (eg, city) []:New York City
# Organization Name (eg, company) [Internet Widgits Pty Ltd]:Bouncy Castles, Inc.
# Organizational Unit Name (eg, section) []:Ministry of Water Slides
# Common Name (e.g. server FQDN or YOUR name) []:your_domain.com
# Email Address []:admin@your_domain.com


# CSR CHECK 
# https://cryptoreport.geotrust.com/checker/views/csrCheck.jsp

# https://products.geotrust.com/orders/orderinformation/authentication.do
# erf75es@gmail.com
# Order ID 9216822 