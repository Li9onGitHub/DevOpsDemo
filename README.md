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
