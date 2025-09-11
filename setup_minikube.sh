#!/bin/bash
# ===========================================
# Full Docker + Minikube Setup Script for RHEL 9
# ===========================================

# Log all output
exec > >(tee -i ~/minikube_docker_setup.log) 2>&1

echo "🟢 Starting full Docker + Minikube setup as user: $USER"

# 1️⃣ Ensure the script is run as a normal user
if [ "$EUID" -eq 0 ]; then
    echo "❌ Do NOT run this script as root. Exiting..."
    exit 1
fi

# 2️⃣ Remove podman-docker if it exists
if rpm -q podman-docker &>/dev/null; then
    echo "🔹 Removing podman-docker..."
    sudo dnf remove -y podman-docker
fi

# 3️⃣ Add Docker CE repo
echo "🔹 Adding Docker CE repository..."
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo

# 4️⃣ Install Docker Engine and plugins
echo "🔹 Installing Docker Engine..."
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 5️⃣ Enable and start Docker service
echo "🔹 Enabling and starting Docker service..."
sudo systemctl enable --now docker

# 6️⃣ Verify Docker
echo "🔹 Docker version:"
docker version

# 7️⃣ Cleanup any old Minikube clusters
echo "🧹 Cleaning up old Minikube resources..."
minikube delete --all --purge || true

# 8️⃣ Start Minikube using Docker driver
CPUS=2
MEMORY=2048
echo "🚀 Starting Minikube with $CPUS CPUs and $MEMORY MB RAM..."
minikube start --driver=docker --cpus=$CPUS --memory=$MEMORY --force

# 9️⃣ Verify Minikube status
echo "🔎 Verifying Minikube status..."
minikube status
kubectl get nodes

echo "🎉 Docker + Minikube setup completed successfully!"

