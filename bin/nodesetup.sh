#!/bin/sh
# Stop and disable the firewalld
#sudo systemctl stop firewalld
#sudo systemctl disable firewalld

# Stop and disable the iptables
#sudo systemctl stop iptables
#sudo systemctl disable iptables

# Disable SELinux
sudo setenforce 0
sudo sed -i 's/enforcing/permissive/' /etc/sysconfig/selinux

# Create the user
sudo useradd --create-home -u 1234 datarobot

# Configure for ssh
sudo mkdir -p /home/datarobot/.ssh && sudo chmod 700 /home/datarobot/.ssh
sudo ssh-keygen -t rsa -b 2048 -f /home/datarobot/.ssh/id_rsa -N ""
sudo cp /home/datarobot/.ssh/id_rsa.pub /home/datarobot/.ssh/authorized_keys

# set the permissions
sudo chown -R datarobot:datarobot /home/datarobot/.ssh
sudo chmod 644 /home/datarobot/.ssh/id_rsa.pub
sudo chmod 600 /home/datarobot/.ssh/id_rsa
sudo chmod 600 /home/datarobot/.ssh/authorized_keys

# Enable sudo for the datarobot user
sudo echo 'datarobot ALL=(ALL) NOPASSWD: ALL' >> ./datarobot
sudo mv datarobot /etc/sudoers.d/
sudo chown root:wheel /etc/sudoers.d/datarobot

# Add the docker group
sudo groupadd docker

# Add the datarobot user to the docker group
sudo usermod -aG docker datarobot

### Install directory set up ###
# Create the DataRobot directory's
sudo mkdir -p /opt/datarobot/DataRobot-INSTALL
sudo mkdir -p /opt/datarobot/DOCKER

# Create the docker symlink
sudo ln -s /opt/datarobot/DOCKER /var/lib/docker

# Take care of the datarobot permissions
sudo chown -R datarobot:datarobot /opt/datarobot