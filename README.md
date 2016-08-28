# DevOpsDemo
This project is focused on fast deployement of chef infrastructure in AWS

## Components
The following things are part of this project:
 - CloudFormation template to start services in AWS
 - ansible roles for:
    - Chef Server
    - Chef Workstation
    - Chef Compliance
    - Chef Automate
 - ansible playbooks to deploy overall infrastructure

## Before you begin
It is assumed that all servers are deployed used the same ssh key. SSH private key will be used during automation process.
Chef Automate requires a license to install Chef Automate server. Please visit chef.io to get the license file.

## Directories
 - cloudformation - it has CloudFormation template for AWS
 - ansible - all required ansible files to deploy Chef Services
 - scripts - it has sctipts to deploy ansible server

## Usage
### Deploy AWS infrastructure
1. Copy CloudFormation template (aws-devops-infrastructure.json) to your workstation: https://github.com/Li9onGitHub/DevOpsDemo/blob/master/cloudformation/aws-devops-infrastructure.json
2. Open AWS page
3. Goto Servies/CloudFormation page
4. Click on "Create Stack" 
5. Click on "Choose File" and choose cloudformation which were recently stored on your workstaion
6. Click "Next"
7. On the "Specify Details" page fill in the following:
 - Stack name
 - Key Pair
8. Click "Next"
9. On the "Options" page click "Next"
10. On the "Review" page click "Create"

The CloudFormation template installs the following servers:
 - workstaion01 - it will be used as an ansible and chef workstaion host (CentOS 7)
 - chefserver01 - Chef Servdr will be installed here (CentOS 7)
 - chefautomate01 - Chef Automate service (CentOS 7)
 - buildnode0{1..3} - Chef Automate build nodes (CentOS 7)
 - acceptance01 - this server will be used as an acceptance host in Automate infrastrucure (Ubuntu)
 - union01 - union host (Ubuntu)
 - rehearsal01 - rehearsal host (Ubuntu)
 - delivered01 - production host (Ubuntu)

### Prepare ansible host (workstaion01)
1. Connect to workstaion01 host using SSH key authentication (Username: centos)
2. Become root user
```
sudo su -
```
2. Install required software (git/ansible)
```
yum -y install  epel-release -y
yum -y install git ansible ansible-lint wget vim -y
```
3. Clone this repository to workstaion01
```
cd /root
git clone https://github.com/Li9onGitHub/DevOpsDemo.git
```
4. Replace ansible configuration files
```
rm -rf /etc/ansible/*
cp -rf /root/DevOpsDemo/ansible/* /etc/ansible/
```
5. Prepare AWS Private Key and put in on workstaion
```
vi /etc/ansible/keys/devops.key
```
Don't forget to paste key text to the file

6. Change permissions to the key file
```
chmod 0600 /etc/ansible/keys/devops.key
chown root /etc/ansible/keys/devops.key
```
7. Check ansible connectivity
```
ansible -m ping all
10.0.0.12 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
10.0.0.11 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
10.0.0.22 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
10.0.0.20 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
10.0.0.23 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
10.0.0.14 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
10.0.0.13 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
10.0.0.18 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
10.0.0.24 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
10.0.0.15 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
10.0.0.16 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
10.0.0.25 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
10.0.0.17 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```
If you see that hosts are unavailable than check your private key



### Install and configure services
