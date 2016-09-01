#!/bin/bash
# this script prepares ansible server to deploy the infrastructure

yum -y install  epel-release -y
yum -y install git ansible ansible-lint wget vim -y
cd /root
git clone https://github.com/Li9onGitHub/DevOpsDemo.git
rm -rf /etc/ansible/*
cp -rf /root/DevOpsDemo/ansible/* /etc/ansible/
mkdir /etc/ansible/keys
mkdir /etc/ansible/files


echo "!!!!NOTE!!!"
echo "Before you begin you must:"
echo
echo "################ SSH KEY ##################"
echo "Please be aware that SSH private key should be copied to /etc/ansible/keys/devops.key"
echo "Do not forget to configure proper permissions: # chmod 0600 /etc/ansible/keys/devops.key"
echo
echo "################ Chef Automate license file ##############"
echo "Chef Automate license file should be copied to /etc/ansible/files/automate.license"
echo

