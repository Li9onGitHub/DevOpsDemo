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
1. Copy cloudformation template to your workstation: https://github.com/Li9onGitHub/DevOpsDemo/blob/master/cloudformation/aws-devops-infrastructure.json
2. 
