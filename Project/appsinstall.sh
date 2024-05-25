#!/bin/bash
sudo yum update -y

#---------------git install ---------------

sudo yum install git -y


#-------java dependency for jenkins------------

sudo dnf install java-11-amazon-corretto -y

#------------jenkins install-------------
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins


# ------------------install terraform ------------------

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform