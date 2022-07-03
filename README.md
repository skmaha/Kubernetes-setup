# Kubernetes-setup
Setup Kubernetes on Centos7

#Get secret token to login to kubernetes-dashboard
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
