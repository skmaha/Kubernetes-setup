#!/bin/bash

# Update hosts file
echo "[Step 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
10.37.129.10 k8smaster.example.com k8smaster
10.37.129.11 k8sworker1.example.com k8sworker1
10.37.129.12 k8sworker2.example.com k8sworker2
EOF

#install extra packages
echo "[Step 1-1] install extra packages"
apt-get install -y wget vim  epel-release ansible >/dev/null 2>&1

# Install docker from Docker-ce repository
echo "[Step 2] Install docker container engine"
sudo apt-get -y update >/dev/null 2>&1
sudo apt-get -yinstall ca-certificates curl gnupg lsb-release >/dev/null 2>&1
sudo mkdir -p /etc/apt/keyrings >/dev/null 2>&1
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get -y update >/dev/null 2>&1
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin >/dev/null 2>&1

# Enable docker service
echo "[Step 3] Enable and start docker service"
systemctl enable docker >/dev/null 2>&1
systemctl start docker >/dev/null 2>&1

#Add Docker daemon.json file at location /etc/docker/
echo "[Step 3.1] Add Docker daemon.json file"
cat >>/etc/docker/daemon.json<<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
systemctl restart docker

# Enable kernel modules
echo "[Step 5] nable kernel modules"
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

# Add sysctl settings
echo "[Step 6] Add sysctl settings"
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sysctl --system >/dev/null 2>&1

# Disable swap
echo "[Step 7] Disable and turn off SWAP"
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a


# Add apt-get repo file for Kubernetes
echo "[Step 8] Add apt-get repo file for kubernetes"
sudo apt-get -y update && sudo apt-get install -y apt-transport-https ca-certificates curl >/dev/null 2>&1
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg >/dev/null 2>&1
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list >/dev/null 2>&1


# Install Kubernetes
echo "[Step 9] Install Kubernetes (kubeadm, kubelet and kubectl)"
sudo apt -y update >/dev/null 2>&1
sudo apt -y install vim git curl wget kubelet kubeadm kubectl >/dev/null 2>&1
sudo apt-mark hold kubelet kubeadm kubectl >/dev/null 2>&1


# Start and Enable kubelet service
echo "[Step 10] Enable and start kubelet service"
sudo systemctl enable --now kubelet >/dev/null 2>&1
sudo systemctl start kubelet >/dev/null 2>&1

#Remove containerd if there was an issue
echo "[Step 10-1] Remove /etc/containerd/config.toml file"
sudo rm -rf /etc/containerd/config.toml
sudo systemctl restart containerd

# Enable ssh password authentication
echo "[Step 11] Enable ssh password authentication"
#sudo apt-get install openssh-server && sudo ufw allow ssh >/dev/null 2>&1
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && systemctl reload sshd >/dev/null 2>&1

# Set Root password
echo "[Step 12] Set root password"
echo "root:kubeadmin" | sudo chpasswd
#echo "kubeadmin" | passwd --stdin root

# Update vagrant user's bashrc file
echo "export TERM=xterm" >> /etc/bashrc
sudo apt-get install -q -y sshpass >/dev/null 2>&1
