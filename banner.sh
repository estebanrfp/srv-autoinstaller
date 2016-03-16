#!/bin/bash

#banner /etc/ssh/sshd_config

cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed -i '/Banne/s/^#//g' /etc/ssh/sshd_config

cat > /etc/issue.net << "EOF"
Ubuntu 15.10
###############################################################
#              Welcome to desarrolloactivo.com                #
#         All connections are monitored and recorded          #
#  Disconnect IMMEDIATELY if you are not an authorized user!  #
###############################################################
EOF