#!/bin/bash

# Join worker nodes to the Kubernetes cluster
echo "[Step 1] Join node to Kubernetes Cluster"
sudo apt-get install -q -y sshpass >/dev/null 2>&1
sudo sshpass -p "kubeadmin" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no k8smaster.example.com:/joincluster.sh /joincluster.sh 2>/dev/null
bash /joincluster.sh >/dev/null 2>&1