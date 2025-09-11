#!/bin/bash
# ===========================================
# Full Cleanup of Podman and Minikube Artifacts
# ===========================================

echo "🧹 Cleaning old Minikube and Podman resources..."

# 1️⃣ Stop and remove all Podman containers (rootless)
echo "🔹 Stopping and removing all Podman containers..."
podman ps -a -q | xargs -r podman rm -f

# 2️⃣ Remove all Podman volumes
echo "🔹 Removing all Podman volumes..."
podman volume ls -q | xargs -r podman volume rm

# 3️⃣ Delete all Minikube clusters
echo "🔹 Deleting all Minikube clusters..."
minikube delete --all --purge || true

# 4️⃣ Remove leftover Minikube files
echo "🔹 Removing Minikube config and cache..."
rm -rf ~/.minikube ~/.kube

echo "✅ Cleanup complete. You are now ready for Docker-based Minikube setup!"

