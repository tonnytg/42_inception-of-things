#!/bin/bash

sudo mkdir -p /home/vagrant/.ssh

sudo cp /vagrant_data/iot_42 /home/vagrant/.ssh/iot_42
sudo cp /vagrant_data/iot_42.pub /home/vagrant/.ssh/iot_42.pub
sudo cp /vagrant_data/node-token /tmp/node-token
sudo chmod 600 /home/vagrant/.ssh/iot_42

cat /home/vagrant/.ssh/iot_42.pub >> /home/vagrant/.ssh/authorized_keys

sudo chown -R vagrant:vagrant /home/vagrant/.ssh

MASTER_IP=192.168.56.110
cp /vagrant_data/node-token /tmp/node-token
TOKEN=$(cat /tmp/node-token)

curl -sfL https://get.k3s.io | K3S_URL=https://$MASTER_IP:6443 K3S_TOKEN=$TOKEN sh -

sudo ln -sf /usr/local/bin/kubectl /usr/bin/kubectl

kubectl version --client

echo "K3S Worker connected to Master!"
