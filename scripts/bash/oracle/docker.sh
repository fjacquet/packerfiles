#!/bin/bash

echo "==> Run the Docker installation script"
curl -sSL https://get.docker.com | sh

echo "==> Create the docker group"
# Add the docker group if it doesn't already exist
groupadd docker

echo "==> Add the connected "${USER}" to the docker group."
gpasswd -a ${USER} docker
gpasswd -a ${SSH_USERNAME} docker

echo "==> Starting docker"
systemctl start docker
echo "==> Enabling docker to start on reboot"
systemctl enable docker
