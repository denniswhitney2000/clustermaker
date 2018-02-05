#!/bin/sh

# this part is a tad insecure.
# reconsider how we do this
# Stop and disable the firewalld
systemctl stop firewalld && systemctl disable firewalld

# Stop and disable the iptables
systemctl stop iptables && systemctl disable iptables

# Disable the SELinux
setenforce 0
sed -i 's/enforcing/permissive/' /etc/sysconfig/selinux
#######

# Create the users and groups
useradd --create-home -u 1234 datarobot
groupadd docker
usermod -aG docker datarobot

# Create the DataRobot directory's
mkdir -p /opt/datarobot/DataRobot-4.0.2
mkdir -p /opt/datarobot/DOCKER

# Create the docker symlink
ln -s /opt/datarobot/DOCKER /var/lib/docker

# Take care of the datarobot permissions
chown -R datarobot:datarobot /opt/datarobot

# Enable sudo for the datarobot user
echo 'datarobot ALL=(ALL) NOPASSWD: ALL' >> ./datarobot
mv datarobot /etc/sudoers.d/
chown root:wheel /etc/sudoers.d/datarobot
