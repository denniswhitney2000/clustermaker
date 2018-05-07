#!/bin/sh
# Set your version
version=INSTALL

# Disable SELinux
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=permissive/' /etc/sysconfig/selinux

# Enable Public Key Authentication
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#RSAAuthentication yes/RSAAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd

# Create the user
useradd --create-home -u 1234 datarobot

# Configure ssh for rsa key authentication
mkdir -p /home/datarobot/.ssh && chmod 700 /home/datarobot/.ssh
ssh-keygen -t rsa -b 2048 -f /home/datarobot/.ssh/id_rsa -N ""
cp /home/datarobot/.ssh/id_rsa.pub /home/datarobot/.ssh/authorized_keys

# set the permissions on the generated files
chown -R datarobot:datarobot /home/datarobot/.ssh
chmod 644 /home/datarobot/.ssh/id_rsa.pub
chmod 600 /home/datarobot/.ssh/id_rsa
chmod 600 /home/datarobot/.ssh/authorized_keys

# Enable sudo for the datarobot user
echo 'datarobot ALL=(ALL) NOPASSWD: ALL' >> ./datarobot
mv datarobot /etc/sudoers.d/
chown root:root /etc/sudoers.d/datarobot

# Add the docker group
groupadd docker

# Add the datarobot user to the docker group
usermod -aG docker datarobot

# Mount the new drive to the node
echo -e "o\nn\np\n1\n\n\nw" | fdisk /dev/xvdb
mkfs.ext4 /dev/xvdb1
mkdir -p /opt/datarobot
mount -t ext4 /dev/xvdb1 /opt/datarobot

# Add entry to the fstab
chmod 666 /etc/fstab
echo "/dev/xvdb1 /opt/datarobot ext4 defaults 0 0" >> /etc/fstab
chmod 644 /etc/fstab

### Install directory set up ###
# Create other DataRobot directories
mkdir -p /opt/datarobot/DataRobot-${version}
mkdir -p /opt/datarobot/DOCKER

# Create the docker symlink
ln -s /opt/datarobot/DOCKER /var/lib/docker

# Take care of the datarobot permissions
chown -R datarobot:datarobot /opt/datarobot