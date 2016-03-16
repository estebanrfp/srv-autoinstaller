#!/bin/bash
echo -e "\033[0;32m INSTALLING...\e[0m"

echo -e "\033[0;32m SWAP SPACE\e[0m"
# SWAP SPACE
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo sh -c 'echo "/swapfile none swap sw 0 0" >> /etc/fstab'

echo -e "\033[0;32m FIX LOCALES\e[0m"

# FIX LOCALES
echo LC_ALL=\'en_US.UTF-8\' >> /etc/environment
sudo locale-gen en_US.UTF-8
export LC_ALL=C
sudo dpkg-reconfigure locales

# FIX DIALOG
export DEBIAN_FRONTEND="noninteractive"

echo -e "\033[0;32m GRUB_HIDDEN_TIMEOUT=0\e[0m"
#comment #GRUB_HIDDEN_TIMEOUT=0
sed -i '/GRUB_HIDDEN_TIMEOUT/s/^/#/g' /etc/default/grub
sudo update-grub

echo -e "\033[0;32m ADD SAFE USER\e[0m"
# ADD SAFE USER
useradd -s /bin/bash -m -d /home/ubuntu -c "ubuntu" ubuntu
gpasswd -a ubuntu sudo
echo ubuntu:$rootpassword | /usr/sbin/chpasswd

echo -e "\033[0;32m COPY AUTHORIZED_KEYS TO UBUNTU .SSH USER\e[0m"
# COPY AUTHORIZED_KEYS TO UBUNTU .SSH USER
sudo -u ubuntu ssh-keygen -q -b 4096 -t rsa -N "" -f ~ubuntu/.ssh/id_rsa
cat ~/.ssh/authorized_keys > ~ubuntu/.ssh/authorized_keys
chown ubuntu:ubuntu ~ubuntu/.ssh/authorized_keys

echo -e "\033[0;32m UPDATE & UPGRADE SYSTEM\e[0m"
# UPDATE & UPGRADE SYSTEM
apt-get -y update;
apt-get -y upgrade;
apt-get -y dist-upgrade;
apt-get -y autoremove;

# ADD SOME LIBRARY
echo -e "\033[0;32m ADD SOME LIBRARY\e[0m"
apt-get install -y curl openssl libssl-dev pkg-config;
apt-get install -y dialog

# RUN PERMISSIONS
chmod u+x /srv-autoinstaller/*.sh

# NGINX
echo -e "\033[0;32m INSTALL NGINX\e[0m"
echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/nginx-stable.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C
sudo apt-get -y update
sudo apt-get -y install nginx

# SSL
echo -e "\033[0;32m SSL CERTIFICATE\e[0m"
./srv-autoinstaller/ssl.sh
  
# NODEJS
echo -e "\033[0;32m INSTALL NODEJS\e[0m"
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
apt-get install -y nodejs

# BUILD ESSENTIAL
echo -e "\033[0;32m BUILD ESSENTIAL\e[0m"
apt-get install -y build-essential

# NPM UPDATE
echo -e "\033[0;32m NPM UPDATE\e[0m"
npm update npm -g
node -v

# INSTALL GIT
echo -e "\033[0;32m INSTALL GIT\e[0m"
apt-get install -y git

# ADD-GITHUB-RSA-PUB
echo -e "\033[0;32m ADD-GITHUB-RSA-PUB\e[0m"
ssh-keygen -q -b 4096 -t rsa -N "" -f ~/.ssh/id_rsa

# PM2
echo -e "\033[0;32m INSTALL PM2\e[0m"
npm install pm2 -g
sudo su -c "env PATH=$PATH:/usr/bin pm2 startup linux -u ubuntu --hp /home/ubuntu"

# HTOP
echo -e "\033[0;32m INSTALL HTOP\e[0m"
./srv-autoinstaller/htop.sh

# MONGODB
echo -e "\033[0;32m INSTALL MONGODB\e[0m"
./srv-autoinstaller/mongodb.sh

# WEBSERVER
echo -e "\033[0;32m INSTALL WEBSERVER\e[0m"
./srv-autoinstaller/webserver.sh

# UFW
echo -e "\033[0;32m INSTALL UFW\e[0m"
./srv-autoinstaller/ufw.sh

# SECLOGIN
echo -e "\033[0;32m SECLOGIN\e[0m"
sed -i -e '/^PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
# sed -i 's/^\(PermitRootLogin\s\)[yY][eE][sS]/\1without-password/' /etc/ssh/sshd_config
sed -i -e '/^UsePAM/s/^.*$/UsePAM no/' /etc/ssh/sshd_config
sed -i -e '/^#PasswordAuthentication/s/^.*$/PasswordAuthentication no/' /etc/ssh/sshd_config

# ChangeSSHPort
sed -i -e '/^Port/s/^.*$/Port '${SSHPort}'/' /etc/ssh/sshd_config

# FAIL2BAN
echo -e "\033[0;32m INSTALL FAIL2BAN\e[0m"
./srv-autoinstaller/fail2ban.sh

# NTP
echo -e "\033[0;32m INSTALL NTP\e[0m"
./srv-autoinstaller/ntp.sh


# SECURITY CHECK
echo -e "\033[0;32m INSTALL LYNIS\e[0m"
sudo apt-get install -y lynis

# UNATTEDED-UPGRADES
# echo -e "\033[0;32m INSTALL UNATTENDED\e[0m"
# ./srv-autoinstaller/unattended.sh

echo -e "\033[0;32m END SMALL INSTALATION !\e[0m"

service ssh restart
