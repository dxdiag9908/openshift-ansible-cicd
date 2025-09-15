#!/bin/bash

echo "=== Step 1: Check Docker status ==="
if ! systemctl is-active --quiet docker; then
    echo "Docker is not running. Starting Docker..."
    sudo systemctl start docker
else
    echo "Docker is running ✅"
fi

echo
echo "=== Step 2: Check if 'webapp' container is running ==="
if docker ps --format '{{.Names}}' | grep -q '^webapp$'; then
    echo "Container 'webapp' is running ✅"
else
    echo "Container 'webapp' is NOT running. Starting container..."
    ansible-playbook -i inventory.ini deploy-app.yml
fi

echo
echo "=== Step 3: Show container port mapping ==="
docker ps | grep webapp

echo
echo "=== Step 4: Get VM IP for browser access ==="
VM_IP=$(hostname -I | awk '{print $1}')
echo "Access Nginx at: http://$VM_IP:8080 (if using VM) or http://localhost:8080 (if local GUI)"

echo
echo "=== Step 5: Check firewall for port 8080 ==="
if sudo firewall-cmd --list-ports | grep -q '8080/tcp'; then
    echo "Port 8080 is already open ✅"
else
    echo "Opening port 8080 in firewall..."
    sudo firewall-cmd --add-port=8080/tcp --permanent
    sudo firewall-cmd --reload
    echo "Port 8080 is now open ✅"
fi

echo
echo "=== Step 6: Test access with curl ==="
curl -s http://localhost:8080 | head -n 5
echo
echo "If you see HTML output above, Nginx is working!"

