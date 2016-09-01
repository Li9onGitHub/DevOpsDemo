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
Both this files should be public available for curl/wget from OS instance.

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
 - Location of Chef Automate license file
 - Lication of SSH Private key specified in "Key Pair"
 - AutomationType
   - auto - to start ansible sctipts automatically
   - manual - do not start ansible, only create AWS infrastructure
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

### Prepare ansible host (workstaion01, only for "manual")
NOTE! This section is only needed when you specified "manual" InstallationType
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
   ...
   ```
   If you see that hosts are unavailable than check your private key
   **NOTE! There is a script on scripts directory which can automate that activities**


### Install and configure services
The ansible automation gives the fully automated installation of all required Chef Services for demo purposes. 
It is enough to start installation process by running "ansible-playbook /etc/ansible/playbooks/deploy.yaml"
```
ansible-playbook /etc/ansible/playbooks/deploy.yaml
```
The process will take ~ 30 mins
NOTE! if "auto" InstallationType it will be run automatically

### Outputs
The automation gives the following default outputs:

1. **Chef Server**
 - Local hostname: chefserver01.example.com
 - Local IP: 10.0.0.11
 - Link: https://chefserver01.example.com
 - User1: chefroot (with 'PASSWORD') which has admin privileges
 - User2: delivery (with 'PASSWORD') which has admin privileges
 - Organization1: exampleorg (chefroot is attached to that org)
 - Organization2: exampleinc (delivery is attached to that org)
 - More information: /etc/ansible/roles/chefserver/defaults/main.yaml
2. **Chef Workstaion**
 - Local hostname: workstaion01.example.com
 - Local IP: 10.0.0.24
 - Link: N/A
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
 - Link: https://chefcompliance01.example.com
 - Chef Server integration is in place
 - Please visit https://<PublicIP> to complete installation process
4. **Chef Automate Server**
 - Local hostname: chefautomate01.example.com
 - Local IP: 10.0.0.12
 - Link: https://chefautomate01.example.com
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

## Check the installation

1. Setup local name resolution (hosts file)

There is no DNS service and to user sevices from internet it is required to change your local hosts file.
   For Linux: /etc/hosts
   For Windwows: C:\Windows\System32\Drivers\etc\hosts
   Public IP addresses can be given by CloudFormation outputs or directly from AWS interface for each service
   Example host file:
   ```
   54.161.131.124	chefcompliance.example.com chefcompliance01
   54.161.157.148	chefautomate01.examle.com chefautomate01
   54.88.68.183	rehearsal01.example.com rehearsal01
   54.164.148.55	chefserver01.example.com chefserver01
   54.164.144.200	acceptance01.example.com acceptance01
   54.152.201.97	union01.example.com union01
   52.87.196.223	workstaion01.example.com workstaion01
   54.85.54.247	delivered01.example.com delivered01
   ```
2. Complete Chef Compliance installation:
   Visit http://chefcompliance01.example.com and compelete installation steps. If local hosts file was not configured - visit https://CompliancePublicIPAddress/
3. Check environments, nodes, cookbooks

   Connect to workstaion and run the following:
   ```
   $ sudo su - chefuser
   $ cd ~/chef-repo1
   $ knife environment list
   _default
   acceptance-demoent-exampleinc-lamp-master
   delivered
   rehearsal
   union
   $ knife  node list
   acceptance01
   buildnode01.example.com
   buildnode02.example.com
   buildnode03.example.com
   chefautomate01
   chefcompliance01
   chefserver01
   delivered01
   rehearsal01
   union01
   workstation01
   ```
5. Check availability of Chef server management console

   - Visit https://chefserver01.example.com
   - Use chefroot/PASSWORD
6. Check availability of Chef Automate web console

   - Visit https://chefautomate01.example.com
   - Use chefroot/PASSWORD or delivery/PASSWORD


# Configure Chef Automate application
## Environment
The environment has 4 application nodes:
 - acceptance01
 - union01
 - rehearsal01
 - delivered01
Chef Automate service was installed and configured but it still doesn't have any application to deploy. This requires to perform several activities to allow Chef Automate to deliver the application to your demo application services.
Source code providers for this demo:
 - local
 - github

## lamp
There is a project https://github.com/Li9onGitHub/lamp which has a simple LAMP application for Ubuntu hosts. it is a demo application which can be controlled by Chef Automate. The automation process already uploaded this cookbook to Chef Server with all required dependencies.

## Configure Chef Automate Application
1. Visit https://chefautomate01.example.com and login using the following parametres:
 - Enterprise: demoent
 - Username: chefuser
 - Password: PASSWORD
2. On "Workflow -> Workflow Org" create a new "exampleinc" organization by "+NEW WORKFLOW ORG" 
3. Connect to Chef Workstation using chefuser OS account 
4. Ensure that lamp cookbook exists on Chef Server:

   ```
   cd /home/chefuser/cher-repo1
   knife cookbook show lamp
   ```
5. Add lamp cookbook to runlist on all application nodes:

   ```
   knife  node run_list add acceptance01 "recipe[lamp]"
   knife  node run_list add union01 "recipe[lamp]"
   knife  node run_list add rehearsal01 "recipe[lamp]"
   knife  node run_list add delivered01 "recipe[lamp]"
   ```
6. Apply lamp cookbook on all nodes by push jobs:

   ```
   knife job start 'chef-client' --search 'recipes:delivery-base'
   ```
   This will take some time to be completed
7. Configure Chef Automate Client

   ```
   delivery setup --server=chefautomate01.example.com --ent=demoent --org=exampleinc --user=chefuser
   ```
   it will ask for chefuser password (type 'PASSWORD')
8. Configure git idenity:

   ```
   git config --global user.email "you@example.com"
   git config --global user.name "Your Name"
   ```
9. Clone the project

   ```
   cd
   git clone https://github.com/Li9onGitHub/lamp.git
   ```
10. Init repository

   ```
   delivery init -c .delivery/config.json
   ```
11. Visit Chef Automate page to see the changes: https://chefautomate01.example.com/e/demoent/#/organizations/exampleinc/projects/lamp/changes

## Update application
1. Get updates to master branch:

   ```
   cd lamp
   git pull --prune
   ```
2. Create a new feature branch

   ```
   git checkout -n myfeature
   vi file1
   vi file2
   vi metadata.rb (don't forget to increase version!!!)
   git add .
   git commit -m 'added new feature'
   delivery review
   ```
3. Visit Chef Automate web page

