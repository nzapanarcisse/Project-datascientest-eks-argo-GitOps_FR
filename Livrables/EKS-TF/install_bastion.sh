#! /bin/bash

sudo apt update -y

cd /tmp
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/local/bin/
sudo chmod 755 /usr/local/bin/kubectl

