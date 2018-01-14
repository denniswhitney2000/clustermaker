#!/bin/sh

# Stop and disable the firewalld
systemctl stop firewalld && systemctl disable firewalld

# Stop and disable the iptables
systemctl stop iptables && systemctl disable iptables

# Disable the SELinux
setenforce 0
sed -i 's/enforcing/permissive/' /etc/sysconfig/selinux

# Create the users and groups
useradd --create-home -u 1234 datarobot
groupadd docker
usermod -aG docker datarobot

# Create the DataRobot directorys
mkdir -p /opt/datarobot/DataRobot-4.0.2
mkdir -p /opt/datarobot/DOCKER

# Create the docker symlink
ln -s /opt/datarobot/DOCKER /var/lib/docker

# Enable sudo for the datarobot user
echo 'datarobot ALL=(ALL) NOPASSWD: ALL' >> ./datarobot
mv datarobot /etc/sudoers.d/
chown root:wheel /etc/sudoers.d/datarobot

# Take care of the datarobot permissions
chown -R datarobot:datarobot /opt/datarobot



# At the bottom of the file, add the following:
#su datarobot
#cd ~/
#ssh-keygen -t rsa
#cat .ssh/id_rsa.pub >> ~/.ssh/authorized_keys
#chmod 600 ~/.ssh/authorized_keys
#ssh -i ~/.ssh/id_rsa localhost date
