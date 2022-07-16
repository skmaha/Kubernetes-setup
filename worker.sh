#!/bin/bash

# Join worker nodes to the Kubernetes cluster
echo "[Step 1] Join node to Kubernetes Cluster"
sudo apt-get install -q -y sshpass >/dev/null 2>&1
sshpass -p vagrant scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no vagrant@k8smaster.example.com:/joincluster.sh /home/vagrant/ 2>/dev/null
bash /home/vagrant/joincluster.sh >/dev/null 2>&1