#!/bin/sh
version=$1

# Stop and disable the firewalld
#sudo systemctl stop firewalld && sudo systemctl disable firewalld

# Disable SELinux
sudo setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=permissive/' /etc/sysconfig/selinux

# Enable Public Key Authentication
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/#RSAAuthentication yes/RSAAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Create the user
sudo useradd --create-home -u 1234 datarobot

# Configure ssh for rsa key authentication
sudo mkdir -p /home/datarobot/.ssh && sudo chmod 700 /home/datarobot/.ssh
sudo ssh-keygen -t rsa -b 2048 -f /home/datarobot/.ssh/id_rsa -N ""
sudo cp /home/datarobot/.ssh/id_rsa.pub /home/datarobot/.ssh/authorized_keys

# set the permissions on the generated files
sudo chown -R datarobot:datarobot /home/datarobot/.ssh
sudo chmod 644 /home/datarobot/.ssh/id_rsa.pub
sudo chmod 600 /home/datarobot/.ssh/id_rsa
sudo chmod 600 /home/datarobot/.ssh/authorized_keys

# Enable sudo for the datarobot user
sudo echo 'datarobot ALL=(ALL) NOPASSWD: ALL' >> ./datarobot
sudo mv datarobot /etc/sudoers.d/
sudo chown root:root /etc/sudoers.d/datarobot

# Add the docker group
sudo groupadd docker

# Add the datarobot user to the docker group
sudo usermod -aG docker datarobot

# prep the data drive to host the DataRobot software and mount it
echo -e "y\n" | sudo mkfs -t ext4 /dev/sdc
sudo mkdir -p /opt/datarobot
sudo mount -t ext4 /dev/sdc /opt/datarobot

# Add entry to the fstab
echo "`sudo file -s /dev/sdc | cut -f 8 -d ' '` /opt/datarobot ext4 defaults,nofail 0 0" | sudo tee -a /etc/fstab

### Install directory set up ###
# Create other DataRobot directories
sudo mkdir -p /opt/datarobot/DataRobot-${version}
sudo mkdir -p /opt/datarobot/DOCKER

# Create the docker symlink
sudo ln -s /opt/datarobot/DOCKER /var/lib/docker

# Take care of the datarobot permissions
sudo chown -R datarobot:datarobot /opt/datarobot