Automated Deployment of a Simple Web Application

This project demonstrates how to automate the deployment of a simple web application using Ansible and Docker, with optional Kubernetes integration. It is designed to run on a RHEL 9 VM and is fully version-controlled via GitHub.

Phase 1: Environment Setup

Prepare the RHEL 9 VM for automation and containerized deployment.

Step 1: Install Ansible

Ansible is the automation tool used throughout this project.

sudo dnf check-update
sudo dnf install ansible -y
ansible --version

Step 2: Initial Container Runtime Setup (Podman)

Originally, Podman was used, but compatibility issues with CRC prevented reliable cluster startup.

sudo dnf install podman -y
podman --version

Step 3: OpenShift CLI (oc)

Required to interact with OpenShift clusters.

sudo dnf install openshift-clients -y
oc version

Step 4: CodeReady Containers (CRC)

A minimal OpenShift cluster for local development.

tar -xvf crc-*.tar.xz
sudo mv crc /usr/local/bin
crc start


⚠️ Note: CRC + Podman on RHEL 9 had compatibility issues, prompting a pivot to Docker.

Phase 2: Pivot to Docker

Due to Podman/CRC issues, Docker is now used as the container runtime.

Step 1: Install Docker
sudo dnf install docker -y
sudo systemctl enable docker
sudo systemctl start docker
docker --version

Step 2: Run Nginx Container via Ansible

We now deploy the web application directly in Docker, without Kubernetes.

Inventory file (inventory.ini)

[local]
localhost ansible_connection=local


Ansible Playbook (deploy-app.yml)

- name: Deploy simple web app using Docker
  hosts: localhost
  gather_facts: no
  tasks:
    - name: Ensure nginx container is running
      community.docker.docker_container:
        name: webapp
        image: nginx:latest
        state: started
        restart_policy: always
        ports:
          - "8080:80"


Run the playbook

ansible-playbook -i inventory.ini deploy-app.yml

Step 3: Verify the Web App

Check container status

docker ps


Access the app

http://localhost:8080   (or http://<VM-IP>:8080 if using VM)


Expected output in browser

Welcome to nginx!
If you see this page, the nginx web server is successfully installed and working.


Firewall (if needed)

sudo firewall-cmd --add-port=8080/tcp --permanent
sudo firewall-cmd --reload

Phase 3: GitHub Version Control

All files, logs, and scripts are tracked using GitHub.

Steps:

Add files to Git:

git add README.md inventory.ini deploy-app.yml verify_webapp.sh


Commit changes:

git commit -m "Phase 3: Docker-based Ansible automation with updated README and verification script"


Pull remote changes with rebase:

git pull --rebase origin main


Resolve any conflicts, then push:

git push origin main

Lessons Learned

Podman vs Docker: Docker provided reliable container runtime for RHEL 9.

Ansible + Docker: Automates deployment with minimal setup.

Version Control: Keeping scripts, playbooks, and documentation in GitHub ensures reproducibility.

Web Verification: Always verify container ports, firewall rules, and VM IP for proper access.

Next Steps

Extend to CI/CD pipelines triggered from GitHub.

Optionally integrate Kubernetes deployment for scaling practice.

Maintain documentation and scripts for future automation projects.
