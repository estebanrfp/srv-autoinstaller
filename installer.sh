#!/bin/bash
echo -e "\033[0;32m INSTALLING...\e[0m"

CONFIG_FILE=/srv-autoinstaller/config.conf

# IMPORT CONFIG FILE
if [[ -f $CONFIG_FILE ]]; then
        . $CONFIG_FILE
fi

echo -e "\033[0;32m SWAP SPACE\e[0m"
# SWAP SPACE
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
# echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab
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
apt-get install -y curl openssl libssl-dev pkg-config;
apt-get install -y dialog

# RUN PERMISSIONS
chmod u+x /srv-autoinstaller/*.sh

# NGINX
if [[ $nginx == yes ]]; then
    ./srv-autoinstaller/nginx.sh
    # SSL
    if [[ $ssl == yes ]]; then
        ./srv-autoinstaller/ssl.sh
    fi    
fi

# NODEJS + NPM UPDATE
if [[ $nodejs == yes ]]; then

    curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
    apt-get install -y nodejs
    apt-get install -y build-essential
    npm update npm -g
    node -v

fi

# GIT
if [[ $gitinst == yes ]]; then
    ./srv-autoinstaller/git-inst.sh
fi

# ADD-GITHUB-RSA-PUB
if [[ -n "$1" ]]; then

    GIT_TOKEN="$1"

    ./srv-autoinstaller/github.sh "${GIT_TOKEN}"

fi

# PM2
if [[ $pm2 == yes ]]; then
    npm install pm2 -g
    sudo su -c "env PATH=$PATH:/usr/bin pm2 startup linux -u ubuntu --hp /home/ubuntu"
fi

# HTOP
if [[ $htop == yes ]]; then
    ./srv-autoinstaller/htop.sh
fi

# GULP
if [[ $gulp == yes ]]; then
    npm install --global gulp
fi

# MONGODB
if [[ $mongodb == yes ]]; then
    ./srv-autoinstaller/mongodb.sh
fi

# BANNER
if [[ $banner == yes ]]; then
    ./srv-autoinstaller/banner.sh
fi

# WEBSERVER
if [[ $webserver == yes ]]; then
    ./srv-autoinstaller/webserver.sh
fi

# DACMS
if [[ $dacms == yes ]]; then
    ./srv-autoinstaller/dacms.sh "${GIT_TOKEN}"
fi

# UFW
if [[ $ufw == yes ]]; then
    ./srv-autoinstaller/ufw.sh
fi

# SECLOGIN
if [[ $secLogin == yes ]]; then
    sed -i -e '/^PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
    # sed -i 's/^\(PermitRootLogin\s\)[yY][eE][sS]/\1without-password/' /etc/ssh/sshd_config
    sed -i -e '/^UsePAM/s/^.*$/UsePAM no/' /etc/ssh/sshd_config
    sed -i -e '/^#PasswordAuthentication/s/^.*$/PasswordAuthentication no/' /etc/ssh/sshd_config
fi

# ChangeSSHPort
if [[ $SSHPort != 22 ]]; then
    sed -i -e '/^Port/s/^.*$/Port '${SSHPort}'/' /etc/ssh/sshd_config
fi

# FAIL2BAN
if [[ $fail2ban == yes ]]; then
    ./srv-autoinstaller/fail2ban.sh
fi

# NTP
if [[ $ntp == yes ]]; then
    ./srv-autoinstaller/ntp.sh
fi

# SECURITY CHECK
if [[ securityCheck == yes ]]; then
    sudo apt-get install -y lynis
fi

# UNATTEDED-UPGRADES
if [[ unattended == yes ]]; then
    ./srv-autoinstaller/unattended.sh
fi

echo -e "\033[0;32m END INSTALATION !\e[0m"

service ssh restart
