#!/usr/bin/env bash

# Based on https://docs.docker.com/install/linux/docker-ce/debian/

echo "Installing Docker..."

# Base software
sudo apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common

# Install pgp key
#curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

# Check Key
# 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88
# sudo apt-key fingerprint 0EBFCD88

# Add repository
#echo "deb [arch=armhf] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
#     $(lsb_release -cs) stable" | \
#    sudo tee /etc/apt/sources.list.d/docker.list
echo "deb [arch=armhf] https://download.docker.com/linux/debian \
     $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list

# Update
sudo apt-get update

# Install
sudo apt-get install -y docker-ce
sudo apt-get install -y docker-compose

# Add user 'osmc' to docker group
sudo usermod -aG docker osmc

