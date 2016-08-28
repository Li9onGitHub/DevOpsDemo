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
3. Install required software (git/ansible)
```
yum -y install  epel-release -y
yum -y install git ansible ansible-lint wget vim -y
```
4. Clone this repository to workstaion01
```
cd /root
git clone https://github.com/Li9onGitHub/DevOpsDemo.git
```
5. Replace ansible configuration files
```
rm -rf /etc/ansible/*
cp -rf /root/DevOpsDemo/ansible/* /etc/ansible/
```
6. Prepare AWS Private Key and put in on workstaion
```
vi /etc/ansible/keys/devops.key
```
Don't forget to paste key text to the file
7. Change permissions to the key file
```
chmod 0600 /etc/ansible/keys/devops.key
chown root /etc/ansible/keys/devops.key
```
8. Put Chef Automate  license file to /etc/ansible/files/automate.license
```
mkdir /etc/ansible/files
cp some_ansible_license_file /etc/ansible/files/automate.license
```
9. Check ansible connectivity
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
NOTE! There is a script on scripts directory which can automate that activities


### Install and configure services
The ansible automation gives the fully automated installation of all required Chef Services for demo purposes. 
It is enough to start installation process by running "ansible-playbook /etc/ansible/playbooks/deploy.yaml"
```
ansible-playbook /etc/ansible/playbooks/deploy.yaml
```
The process will take ~ 30 mins

## Outputs
The automation gives the following default outputs:

1. **Chef Server**
 - Local hostname: chefserver01.example.com
 - Local IP: 10.0.0.11
 - User1: chefroot (with 'PASSWORD') which has admin privileges
 - User2: delivery (with 'PASSWORD') which has admin privileges
 - Organization1: exampleorg (chefroot is attached to that org)
 - Organization2: exampleinc (delivery is attached to that org)
 - More information: /etc/ansible/roles/chefserver/defaults/main.yaml
2. **Chef Workstaion**
 - Local hostname: workstaion01.example.com
 - Local IP: 10.0.0.24
 - ChefDK package is installed
 - OS user: chefroot (you should use "su" to become chefuser)
 - Chef repo1: /home/chefuser/chef-repo1 (it is linked with exampleinc and delivery user)
 - Chef repo2: /home/chefuser/chef-repo2 (it is linked with exampleorg and chefroot user)
 - Organization1: exampleorg (chefroot is attached to that org)
 - Organization2: exampleinc (delivery is attached to that org)
 - More information: /etc/ansible/roles/chefworkstaion/defaults/main.yaml
3. **Chef Compliance**
 - Local hostname: chefcompliance01.example.com
 - Local IP: 10.0.0.20
 - Chef Server integration is in place
 - Please visit https://<PublicIP> to complete installation process
4. **Chef Automate Server**
 - Local hostname: chefautomate01.example.com
 - Local IP: 10.0.0.12
 - User1: chefroot (with 'PASSWORD') which has all  privileges in exampleinc organization
 - User2: manager (with 'PASSWORD') which has observer privileges in exampleinc organization
 - buildnode0{1..3}.example.com are installed and configured as Automate Build Nodes
 - Enterprise: "demoent" is created
 - More information: /etc/ansible/roles/chefautomate/defaults/main.yaml
5. **Additional changes**
 - provided by plabooks, not by chefautomate ansible role
 - all hosts are bootstraped into exampleinc organization
 - delivery-base, delivery-truck and lamp packages are uploaded with all required dependencies
 - The followinf environments are created:
   - acceptance-demoent-exampleinc-lamp-master (acceptance01 is attached to this environment)
   - union (union01 is attached)
   - rehearsal (rehearsal01 is attached)
   - delivered (delivered01 is attached)

