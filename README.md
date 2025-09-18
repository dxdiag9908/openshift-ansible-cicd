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

Inventory (inventory.ini):

[local]
localhost ansible_connection=local


Playbook (deploy-app.yml):

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
docker ps


Open a browser at http://localhost:8080 or http://<VM-IP>:8080
Expected Output: Welcome to nginx!

Open firewall port if needed:

sudo firewall-cmd --add-port=8080/tcp --permanent
sudo firewall-cmd --reload

Phase 3: VM Recovery & Lessons Learned

⚠️ Real-world incident: During the deployment, the RHEL 9 VM became unbootable after running dnf update -y. This section documents the problem, recovery, and lessons learned.

Incident Overview

Trigger: sudo dnf update -y after Docker/Ansible setup.

Symptoms:

VM froze during boot.

Errors such as unmaintained driver detected: pmtbase.

GRUB menu looping, VM could not reach login.

Impact: Original VM unusable; project at risk.

Troubleshooting Steps

Verified boot order and ISO attachment in VMware Workstation Pro.

Attempted BIOS/firmware checks and multiple reboots.

Determined kernel/drivers update caused virtual hardware conflict.

Recovery Process

Step 1 — Backup Old VM

Power off VM completely.

Copy entire VM folder to safe location.

Verify backup contents:

$backupFolder = "D:\VM_Backups\RHEL9-VM_Backup"
Get-ChildItem $backupFolder -Recurse -Filter *.vmdk
Get-ChildItem $backupFolder -Recurse -Filter *.vmx
Get-ChildItem $backupFolder -Recurse -Filter *.nvram


Step 2 — Fresh VM Creation

Create new RHEL 9 VM with Server with GUI.

Allocate 4 GB RAM, 2 CPU cores, 20 GB disk.

Boot from RHEL 9.6 ISO and complete installation.

Step 3 — Attach Old VM Disk

Add old .vmdk backup as secondary disk.

Mount in fresh VM and copy project:

sudo mkdir /mnt/oldvm
lsblk                       # identify disk partition
sudo mount /dev/sdb1 /mnt/oldvm
cp -r /mnt/oldvm/project ~/project
sudo umount /mnt/oldvm


Step 4 — Project Recovery

Project fully restored in fresh VM.

Verified all files, scripts, and previous work intact.

Lessons Learned

Always backup VM before system updates.

Updates can break VM boot unexpectedly.

Systematic troubleshooting: boot order, ISO, BIOS, logs.

Document incidents: professional real-world skill demonstration.

Phase 4: GitHub Version Control

All scripts and playbooks are tracked in GitHub.

Commit Workflow:

git add README.md inventory.ini deploy-app.yml verify_webapp.sh
git commit -m "Phase 4: Docker-based Ansible automation with VM recovery notes"
git pull --rebase origin main   # resolve any conflicts
git push origin main

Lessons Learned

Docker over Podman: Stable, reliable container runtime on RHEL 9.

Ansible Automation: Repeatable, version-controlled deployments.

Verification Matters: Test ports, firewall rules, VM access.

GitHub Integration: Keeps infrastructure organized.

Next Steps

Integrate a CI/CD pipeline triggered from GitHub.

Optionally, deploy on Kubernetes for scaling practice.

Maintain all scripts and documentation for professional portfolio demonstration.
