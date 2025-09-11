#!/bin/bash

LOG_FILE="$HOME/minikube_setup.log"

# Redirect stdout and stderr to log file
exec > >(tee -a "$LOG_FILE") 2>&1

echo "==== Starting Minikube + Podman setup ===="
date

# Check number of CPUs
CPU_COUNT=$(nproc)
echo "Detected CPU cores: $CPU_COUNT"
if [ "$CPU_COUNT" -lt 2 ]; then
    echo "ERROR: Minikube requires at least 2 CPU cores."
    echo "Please increase your VM CPU allocation before continuing."
    exit 1
fi

# Update system packages
echo "Updating system packages..."
sudo dnf update -y

# Install Podman
echo "Installing Podman..."
sudo dnf install -y podman

# Install Minikube
echo "Installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Check versions
echo "Checking installed versions..."
podman --version
minikube version

# Start Minikube with Podman driver (lightweight)
echo "Starting Minikube with Podman driver (lightweight)..."
minikube start --driver=podman --memory=1024 --cpus=2

echo "==== Setup finished ===="
date
echo "Log file: $LOG_FILE"


