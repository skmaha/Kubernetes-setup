# Kubernetes-setup
Setup Kubernetes on Centos7
## Pre-requisites
1. Vagrant installed
2. Oracle Virtual Box installed
3. Create virtual network connection on VirtualBox
4. Update the Vagrant file with IP Address as per the network connection created.

5. clone the repo
6. cd Kubernetes-setup
7. vagrant up

# Commands
1. kubectl get all --all-namespaces
2. kubectl get pod --all-namespaces
3. kubectl get service --all-namespaces
4. kubectl get serviceaccount --all-namespaces
5. kubectl describe deployment deployment-name
6. kubectl describe po pod-name
7. kubectl describe svc svc-name
8. kubectl cp file-name pod-name:/path/to/file/location/
