#!/bin/sh
# Set the DataRobot  version
version=<DR.Version>

# Uncomment the appropreate drive type
disk=nvme1n1   # Use with AWS R5 instance types
#disk=sdb       # Use with AWS R4 instnace types
#disk=sdc       # Use for Azure
#disk=<custom>  # Use for VM ware and other custom environments

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

# For the complete details of the section below, please refer to:
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-using-volumes.html
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/nvme-ebs-volumes.html

# Mount the new drive to the node
mkfs -t ext4 /dev/${disk}
mkdir -p /opt/datarobot
mount -t ext4 /dev/${disk} /opt/datarobot

# Add entry to the fstab
echo "`sudo file -s /dev/${disk} | cut -f 8 -d ' '` /opt/datarobot ext4 defaults,nofail 0 0" | sudo tee -a /etc/fstab

### Install directory set up ###
# Create other DataRobot directories
mkdir -p /opt/datarobot/DataRobot-${version}
mkdir -p /opt/datarobot/DOCKER

# Create the docker symlink
ln -s /opt/datarobot/DOCKER /var/lib/docker

# Take care of the datarobot permissions
chown -R datarobot:datarobot /opt/datarobot