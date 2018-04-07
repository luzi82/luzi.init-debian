#!/bin/bash

set -e

HOSTNAME=`hostname --long`

apt-get update
apt-get dist-upgrade -y
apt-get autoremove -y
apt-get autoclean

# install config sudo
apt-get install sudo gcc -y
usermod -aG sudo luzi82

# ssh key
mkdir -p /home/luzi82/.ssh
cp authorized_keys /home/luzi82/.ssh/
if [ ! -f /home/luzi82/.ssh/id_rsa ]; then
  ssh-keygen -f /home/luzi82/.ssh/id_rsa -t rsa -N '' -C "luzi82@${HOSTNAME}"
fi
chmod 755 /home/luzi82/.ssh
chmod 644 /home/luzi82/.ssh/authorized_keys
chown luzi82:luzi82 -R /home/luzi82/.ssh

# ssh NoDNS
sed -i 's/UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
sed -i 's/#UseDNS no/UseDNS no/g' /etc/ssh/sshd_config

# resolv.conf
echo 'make_resolv_conf() { :; }' > /etc/dhcp/dhclient-enter-hooks.d/leave_my_resolv_conf_alone
chmod 755 /etc/dhcp/dhclient-enter-hooks.d/leave_my_resolv_conf_alone
rm -f /etc/resolv.conf
cp resolv.conf /etc/resolv.conf
chmod 644 resolv.conf

# noip
if [ ! -f /etc/init.d/noip2.sh ]; then
  mkdir ~/noip
  pushd ~/noip
  wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz
  tar -xzvf noip-duc-linux.tar.gz
  cd noip-2.1.9-1
  make
  popd
fi

# final prompt
echo may need reboot
echo may need to update /etc/resolv.conf
echo may need to install noip
