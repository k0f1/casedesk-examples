#!/bin/bash
set -e

# Install NVIDIA drivers
sudo dnf install -y kernel-devel-$(uname -r) kernel-headers-$(uname -r)
sudo dnf install -y nvidia-driver nvidia-driver-cuda

# Install Docker
sudo dnf install -y docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user

# Install NVIDIA Container Toolkit
distribution=$(. /etc/os-release; echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.repo \
  | sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo

sudo dnf install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

echo "Setup complete. Log out and back in for group changes to take effect."
