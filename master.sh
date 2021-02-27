#!/bin/bash

# Initialize Kubernetes
echo "[Step 1] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=192.168.48.10 --pod-network-cidr=192.168.0.0/16 >> /root/kubeinit.log 2>/dev/null

# Copy Kube admin config
echo "[Step 2] Copy kube admin config to Vagrant user .kube directory"
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Deploy Calico network
echo "[Step 3] Deploy Calico network"
su - vagrant -c "kubectl create -f https://docs.projectcalico.org/v3.11/manifests/calico.yaml" 2>/dev/null

# Deploy Kubernetes-dashboard
echo "[Step 4] Deploy Kubernetes-dashboard & dashboard-service account"
su - vagrant -c "kubectl apply -f https://raw.githubusercontent.com/msunilkumar/Kubernetes-setup/master/dashboard.yaml" 2>/dev/null
su - vagrant -c "kubectl apply -f https://raw.githubusercontent.com/msunilkumar/Kubernetes-setup/master/sa-dashboard.yaml" 2>/dev/null

# Generate Cluster join command
echo "[Step 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh
