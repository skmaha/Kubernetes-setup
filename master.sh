#!/bin/bash

# Initialize Kubernetes
echo "[Step 1] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=192.168.56.10 --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log 2>/dev/null

# Copy Kube admin config
echo "[Step 2] Copy kube admin config to Vagrant user .kube directory"
mkdir -p /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Deploy Calico network
echo "[Step 3] Deploy Calico network"
su - vagrant -c "kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml" 2>/dev/null

# Deploy Kubernetes-dashboard
echo "[Step 4] Deploy Kubernetes-dashboard & dashboard-service account"
su - vagrant -c "kubectl apply -f https://raw.githubusercontent.com/msunilkumar/Kubernetes-setup/master/dashboard.yaml" 2>/dev/null
su - vagrant -c "kubectl apply -f https://raw.githubusercontent.com/msunilkumar/Kubernetes-setup/master/sa-dashboard.yaml" 2>/dev/null

# Create dashboard-admin token
echo "[Step 5] Create secret token for dashboard access"
kubectl -n kubernetes-dashboard create token dashboard-admin >/home/vagrant/dashboard-admin.txt

# Create sample nginx and httpd deplyments
su - vagrant -c "https://raw.githubusercontent.com/sunil4356/Kubernetes-setup/master/httpd.yaml"
su - vagrant -c "https://raw.githubusercontent.com/sunil4356/Kubernetes-setup/master/nginx.yaml"

# Generate Cluster join command
echo "[Step 6] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh
