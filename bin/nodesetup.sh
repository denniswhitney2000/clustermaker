#!/bin/sh
# Stop and disable the firewalld
#sudo systemctl stop firewalld
#sudo systemctl disable firewalld

# Stop and disable the iptables
#sudo systemctl stop iptables
#sudo systemctl disable iptables

# Disable the SELinux
sudo setenforce 0
sudo sed -i 's/enforcing/permissive/' /etc/sysconfig/selinux
#######

# Create the users and groups
sudo useradd --create-home -u 1234 datarobot
sudo groupadd docker
sudo usermod -aG docker datarobot

# Create the DataRobot directory's
sudo mkdir -p /opt/datarobot/DataRobot-INSTALL
sudo mkdir -p /opt/datarobot/DOCKER

# Create the docker symlink
sudo ln -s /opt/datarobot/DOCKER /var/lib/docker

# Take care of the datarobot permissions
sudo chown -R datarobot:datarobot /opt/datarobot

# Enable sudo for the datarobot user
sudo echo 'datarobot ALL=(ALL) NOPASSWD: ALL' >> ./datarobot
sudo mv datarobot /etc/sudoers.d/
sudo chown root:wheel /etc/sudoers.d/datarobot
