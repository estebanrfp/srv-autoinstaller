#!/bin/bash

# 2222
sudo sed -i 's/IPV6=no/IPV6=yes/g' /etc/default/ufw
# sudo ufw allow ssh
sudo ufw allow 2222
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 25/tcp
sudo ufw allow 5900/tcp
sudo ufw allow 3001/tcp
sudo ufw allow 8080/tcp
sudo ufw show added
sudo ufw enable
