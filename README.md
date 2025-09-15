🚀 Automated Deployment of a Simple Web Application

This project demonstrates the automation of a web application deployment using Ansible and Docker, fully tested on a RHEL 9 VM.
It is version-controlled with GitHub and designed to showcase professional DevOps practices.

Phase 1: Environment Setup

Prepare the RHEL 9 VM with all necessary tools.

1️⃣ Install Ansible

Ansible automates deployments and infrastructure tasks.

sudo dnf check-update
sudo dnf install ansible -y
ansible --version

2️⃣ Podman (Initial Approach)

Podman was initially used but proved incompatible with CRC on RHEL 9.

sudo dnf install podman -y
podman --version

3️⃣ OpenShift CLI

Install oc to manage OpenShift clusters.

sudo dnf install openshift-clients -y
oc version

4️⃣ CodeReady Containers (CRC)

CRC provides a minimal local OpenShift cluster.

tar -xvf crc-*.tar.xz
sudo mv crc /usr/local/bin
crc start


⚠️ Note: CRC + Podman on RHEL 9 often failed. This led to pivoting to Docker for reliability.

Phase 2: Docker Deployment

Docker replaced Podman to run containers directly.

1️⃣ Install Docker
sudo dnf install docker -y
sudo systemctl enable docker
sudo systemctl start docker
docker --version

2️⃣ Ansible Playbook for Docker

Deploy an Nginx web server container using Ansible.

Inventory (inventory.ini)

[local]
localhost ansible_connection=local


Playbook (deploy-app.yml)

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

3️⃣ Run the Playbook
ansible-playbook -i inventory.ini deploy-app.yml

4️⃣ Verify the Web App

Check container status:

docker ps


Open browser at http://localhost:8080 or http://<VM-IP>:8080

Expected Output:

Welcome to nginx!
If you see this page, the nginx web server is successfully installed and working.


Open firewall port if needed:

sudo firewall-cmd --add-port=8080/tcp --permanent
sudo firewall-cmd --reload

Phase 3: GitHub Version Control

All scripts and playbooks are tracked in GitHub.

Commit Workflow
git add README.md inventory.ini deploy-app.yml verify_webapp.sh
git commit -m "Phase 3: Docker-based Ansible automation with updated README and verification script"
git pull --rebase origin main   # resolve any conflicts
git push origin main

Lessons Learned

Docker over Podman: Provides a stable, reliable container runtime on RHEL 9.

Ansible Automation: Makes deployments repeatable and version-controlled.

Verification Matters: Always test ports, firewall rules, and VM access.

GitHub Integration: Keeps infrastructure and documentation organized.

Next Steps

Integrate a CI/CD pipeline triggered from GitHub.

Optionally, deploy on Kubernetes for scaling practice.

Maintain all scripts and documentation for professional portfolio demonstration.
