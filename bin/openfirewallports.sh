#!/bin/sh
#
# https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-firewalld-on-centos-7
#
echo "Allow SSH"
sudo firewall-cmd --zone=public --permanent --add-port=22/tcp

echo "Allow HTTP"
sudo firewall-cmd --zone=public --permanent --add-service=http

echo "Allow HTTPS"
sudo firewall-cmd --zone=public --permanent --add-service=https
###

echo "Allow UDP Logging"
sudo firewall-cmd --zone=public --permanent --add-port=1514/udp

echo "Allow DataRobot Prediction Optimization User Interface"
sudo firewall-cmd --zone=public --permanent --add-port=3000/tcp

echo "Allow Docker Registry"
sudo firewall-cmd --zone=public --permanent --add-port=5000/tcp

echo "Allow IDE Client Broker/Worker"
sudo firewall-cmd --zone=public --permanent --add-port=5445-5446/tcp

echo "Allow Audit Logs"
sudo firewall-cmd --zone=public --permanent --add-port=5544/udp

echo "Allow Redis"
sudo firewall-cmd --zone=public --permanent --add-port=6379/tcp

echo "Allow Resource Proxy Subscriber/Publisher"
sudo firewall-cmd --zone=public --permanent --add-port=6556-6557/tcp

echo "Allow Queue Proxy Subscriber/Publisher"
sudo firewall-cmd --zone=public --permanent --add-port=6558-6559/tcp

echo "Allow DataRobot Flask Application"
sudo firewall-cmd --zone=public --permanent --add-port=8000/tcp

echo "Allow DataRobot API v0, v1"
sudo firewall-cmd --zone=public --permanent --add-port=8001-8002/tcp

echo "Allow DataRobot API v2"
sudo firewall-cmd --zone=public --permanent --add-port=8004/tcp

echo "Allow DataRobot Socket.IO Server"
sudo firewall-cmd --zone=public --permanent --add-port=8011/tcp

echo "Allow DataRobot Upload Server"
sudo firewall-cmd --zone=public --permanent --add-port=8023/tcp

echo "Allow DataRobot Diagnostics Server"
sudo firewall-cmd --zone=public --permanent --add-port=8033/tcp

echo "Allow DataRobot Prediction Optimization Application"
sudo firewall-cmd --zone=public --permanent --add-port=8097/tcp
sudo firewall-cmd --zone=public --permanent --add-port=9000/tcp

echo "Allow DataRobot Datasets Service API"
sudo firewall-cmd --zone=public --permanent --add-port=8100/tcp

echo "Allow DataRobot Availability Monitor"
sudo firewall-cmd --zone=public --permanent --add-port=9090/tcp

echo "Allow DataRobot PNGExport Service"
sudo firewall-cmd --zone=public --permanent --add-port=9496/tcp

echo "Allow Redis Sentinel"
sudo firewall-cmd --zone=public --permanent --add-port=26379/tcp

echo "Allow MongoDB"
sudo firewall-cmd --zone=public --permanent --add-port=27017/tcp

echo "Allow Worker Broker Client/Broker"
sudo firewall-cmd --zone=public --permanent --add-port=5555-5556/tcp

echo "Allow User Worker Broker Client/Broker"
sudo firewall-cmd --zone=public --permanent --add-port=5558-5559/tcp

echo "Allow Gluster Portmapper Service TCP/UDP"
sudo firewall-cmd --zone=public --permanent --add-port=111/tcp
sudo firewall-cmd --zone=public --permanent --add-port=111/udp

echo "Allow Gluster Daemon/Management/Brick"
sudo firewall-cmd --zone=public --permanent --add-port=24007-24008/tcp

echo "Allow Gluster Brick 1"
sudo firewall-cmd --zone=public --permanent --add-port=24009/tcp

echo "Allow Gluster Brick 2"
sudo firewall-cmd --zone=public --permanent --add-port=49152/tcp

echo "Saving port configuration"
sudo firewall-cmd --reload

echo "Restarting the network"
sudo systemctl restart network

echo "Reloading the firewalld"
sudo systemctl reload firewalld

echo "Display configuration"
sudo firewall-cmd --list-all 