#!/bin/bash

# MONGODB
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list

apt-get -y update
apt-get install -y mongodb-org

# sudo nano /etc/mongod.conf
# Replace dbpath=/var/lib/mongodb TO dbpath=/data/db and then save the file.
# comment line # bind_ip = 127.0.0.1

mkdir -p /data/db
sudo chown -R mongodb:mongodb /data/db
sudo chown -R mongodb /data/db

#sudo service mongod restart

iptables -I INPUT -p tcp -m tcp --dport 27017 -j ACCEPT
iptables-save
service mongod status