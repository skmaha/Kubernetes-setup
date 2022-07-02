#!/bin/bash

# Update hosts file
echo "[Step 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
192.168.48.10 k8smaster.example.com k8smaster
192.168.48.11 k8sworker1.example.com k8sworker1
192.168.48.12 k8sworker2.example.com k8sworker2
EOF

# Install docker from Docker-ce repository
echo "[Step 2] Install docker container engine"
yum install -y -q yum-utils  > /dev/null 2>&1
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo > /dev/null 2>&1
yum install -y -q docker-ce >/dev/null 2>&1

# Enable docker service
echo "[Step 3] Enable and start docker service"
systemctl enable docker >/dev/null 2>&1
systemctl start docker

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

# Disable SELinux
echo "[Step 4] Disable SELinux"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

# Stop and disable firewalld
echo "[Step 5] Stop and Disable firewalld"
systemctl disable firewalld >/dev/null 2>&1
systemctl stop firewalld

# Add sysctl settings
echo "[Step 6] Add sysctl settings"
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system >/dev/null 2>&1

# Disable swap
echo "[Step 7] Disable and turn off SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

# Add yum repo file for Kubernetes
echo "[Step 8] Add yum repo file for kubernetes"
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Install Kubernetes
echo "[Step 9] Install Kubernetes (kubeadm, kubelet and kubectl)"
yum install -y -q kubeadm kubelet kubectl >/dev/null 2>&1

# Start and Enable kubelet service
echo "[Step 10] Enable and start kubelet service"
systemctl enable kubelet >/dev/null 2>&1
systemctl start kubelet >/dev/null 2>&1

#Remove containerd if kubectl fails to start.
echo "[Step 10.1] Remove /etc/containerd/config.toml file if exists"
sudo rm -rf /etc/containerd/config.toml
sudo systemctl restart containerd

# Enable ssh password authentication
echo "[Step 11] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && systemctl reload sshd

# Set Root password
echo "[Step 12] Set root password"
echo "kubeadmin" | passwd --stdin root >/dev/null 2>&1

# Update vagrant user's bashrc file
echo "export TERM=xterm" >> /etc/bashrc

#install extra packages
echo "[Step 13] install extra packages"
yum install -y wget vim  epel-release ansible >/dev/null 2>&1
