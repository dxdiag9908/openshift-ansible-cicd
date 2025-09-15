# Automated Deployment of a Simple Web Application

This project demonstrates how to automate the deployment of a simple web application using **Ansible** and **Docker** on a RHEL 9 VM. It documents environment setup, deployment automation, verification steps, and lessons learned.

---

## Phase 1: Environment Setup

Prepare your RHEL 9 VM with the necessary tools for automation and container management.

### Step 1: Install Ansible

sudo dnf check-update
sudo dnf install ansible -y
ansible --version
Step 2: Install Docker

sudo dnf install docker -y
sudo systemctl enable docker
sudo systemctl start docker
docker --version



Phase 2: Pivot to Docker Deployment
Initially, Minikube with Docker driver was used to simulate Kubernetes.

Due to connectivity issues, Minikube complexity, and RHEL 9 compatibility problems with CRC/Podman, we pivoted to Docker-only deployment for simplicity and reliability.

Key Points:
No Kubernetes cluster is required.

Docker containers run directly on the VM.

Simplifies automation with Ansible and reduces troubleshooting overhead.

Phase 3: Ansible Automation (Docker)
In this phase, we automated deployment of a simple Nginx web application using Ansible and the community.docker collection.

Steps Implemented
Install the community.docker Ansible collection:


ansible-galaxy collection install community.docker
Create an inventory.ini file pointing to localhost:


[local]
localhost ansible_connection=local
Write the Ansible playbook deploy-app.yml:

---
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
          - "8080:80"   # maps localhost:8080 → container:80
Optionally, create a verification script verify_webapp.sh to check Docker status, container health, firewall rules, and browser access.

Running the Playbook
ansible-playbook -i inventory.ini deploy-app.yml

Verification
Check the container is running:
docker ps
Access the application in a browser:

From VM GUI: http://localhost:8080

From another machine on the same network: http://192.168.13.128:8080

Expected Browser Output:


Welcome to nginx!
If you see this page, the nginx web server is successfully installed and working. Further configuration is required.

For online documentation and support please refer to nginx.org.
Commercial support is available at nginx.com.

Thank you for using nginx.
Phase 4: Lessons Learned
Ansible can directly manage Docker containers using the community.docker collection.

Docker-only deployment is lightweight and simpler than a full Kubernetes setup.

Codifying deployments ensures automation, repeatability, and version control.

Pivoting from Minikube resolved cluster connectivity issues and simplified testing.

Phase 5: Next Steps
Extend deployment automation with CI/CD pipelines triggered from GitHub.

Maintain all configuration and deployment scripts version-controlled in GitHub.

Optionally explore full Kubernetes/OpenShift deployment for production scenarios.

Use the verification script (verify_webapp.sh) to quickly confirm deployments
