# Automated Deployment of a Simple Web Application on OpenShift

This project demonstrates how to automate the deployment of a simple web application using Ansible, container runtimes, and OpenShift/Minikube. It documents the environment setup, issues encountered, solutions, and steps to get the project running on a RHEL 9 VM.

---

## Phase 1: Environment Setup

This phase sets up all necessary tools on your RHEL 9 VM. This is a one-time process to prepare your system for the project.

### Step 1: Install Ansible
Ansible is the primary automation tool for this project.  

```bash
# Update the system's package index
sudo dnf check-update

# Install Ansible
sudo dnf install ansible -y

# Verify installation
ansible --version
Step 2: Install Podman (Initial Approach)
Podman is a daemonless container engine suitable for RHEL.

bash
Copy code
# Install Podman
sudo dnf install podman -y

# Verify installation
podman --version
Step 3: Install OpenShift CLI (oc)
The oc CLI is essential for interacting with your OpenShift cluster.

bash
Copy code
# Install OpenShift CLI
sudo dnf install openshift-clients -y

# Verify installation
oc version
Step 4: Install CodeReady Containers (CRC) (Initial Approach)
CRC provides a minimal, single-node OpenShift cluster for local development.

Download CRC from the Red Hat Developer site (requires Red Hat account).

Extract the tarball:

bash
Copy code
tar -xvf crc-*.tar.xz
Move the crc executable to a directory in your PATH:

bash
Copy code
sudo mv crc /usr/local/bin
Start CRC with the pull secret:

bash
Copy code
crc start
⚠️ Problem Encountered: CRC and Podman on RHEL 9 had compatibility issues that prevented the OpenShift cluster from starting reliably.

Phase 2: Pivot to Docker and Minikube
Due to Podman/CRC issues, we switched to Docker as the container runtime and Minikube to run a local Kubernetes cluster.

Step 1: Install Docker
Docker is used as the container runtime for Minikube.

bash
Copy code
sudo dnf install docker -y
sudo systemctl enable docker
sudo systemctl start docker
docker --version
Step 2: Install Minikube
Minikube provides a local Kubernetes cluster for testing and development.

bash
Copy code
# Download Minikube (latest version)
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

# Install Minikube
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Verify installation
minikube version
Step 3: Start Minikube
We configured Minikube to use Docker with 2 CPUs and 2 GB of RAM:

bash
Copy code
minikube start --driver=docker --cpus=2 --memory=2048
✅ Output confirmed the cluster started successfully.

⚠️ Note: The system kubectl version was older than the Kubernetes version used by Minikube. Use the bundled Minikube kubectl to avoid incompatibilities:

bash
Copy code
minikube kubectl -- get pods -A
Step 4: Verify Minikube
bash
Copy code
kubectl get nodes
kubectl get pods -A
Phase 3: Configure GitHub
GitHub is used for version control and project portfolio.

bash
Copy code
# Create a new repository on GitHub (e.g., openshift-ansible-cicd)
# Clone the repository
git clone https://github.com/dxdiag9908/openshift-ansible-cicd.git
cd openshift-ansible-cicd

# Create initial README.md
nano README.md
Paste the content above and save.

Step 5: Commit and Push Changes
bash
Copy code
git add README.md
git commit -m "Update README: document project phases and troubleshooting"
git push origin main
Troubleshooting & Lessons Learned
Podman vs Docker: Podman did not work reliably with CRC on RHEL 9; pivoting to Docker solved container runtime issues.

CRC Issues: CRC required Red Hat pull secrets and often failed due to Podman integration; Minikube provided a simpler local Kubernetes environment.

kubectl Version: Mismatch between system kubectl and Minikube’s Kubernetes version can cause errors. Use minikube kubectl -- ... to avoid issues.

Next Steps
Deploy a simple test pod on Minikube.

Automate deployments with Ansible.

Version control all configuration and deployment scripts in GitHub.

Extend to CI/CD pipeline using OpenShift or local Kubernetes.

yaml
Copy code

