#!/bin/bash
echo "[Step 1] Install Java 11"
sudo yum install java-11-openjdk-devel git wget -y >/dev/null 2>&1
echo "[Step 2] Add kubernetes repo" 
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo && sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key >/dev/null 2>&1
echo "[Step 3] Install Jenkins and start and enable" 
sudo yum install jenkins -y && sudo systemctl start jenkins && sudo systemctl enable jenkins >/dev/null 2>&1
systemctl status jenkins
echo "[Step 4] Add firewall rules"
sudo systemctl start firewalld.service >/dev/null 2>&1
sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp >/dev/null 2>&1
sudo firewall-cmd --reload >/dev/null 2>&1
echo "[Step 5] Print secret key for admin access"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword