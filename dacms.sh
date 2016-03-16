#!/bin/bash

# DACMS WEBSERVER 

sudo ufw allow 8080/tcp

KEY_TOKEN="$1"

sudo -u ubuntu mkdir ~ubuntu/webapps/

# NEW LINK METHOD
