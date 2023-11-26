# Devops

## Description
Codebase for provisioning managed kubernetes (k8s) using infrastructure as code.

### Features
- terraform modules version locked
- mozilla sops protects secrets in code using kms

#### AWS
- Code written following AWS Prescriptive Guidance Security Reference Architecture https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/org-management.html
- MFA enforced org-wide

#### Azure
tbd

#### GCP
tbd

### Goals
- Add Azure code for AKS
- Add GCP code for GKS

### Known Issues
tbd

## Prerequisites

### AWS
- AWS cli 2.13.26
- Terraform v1.6.1
- eksctl
- kubectl
- terraform state backend resources (s3 bucket, dynamodb, and cmk)

### Initial Setup
1. Create single AWS account to be the Org root
1. Create "automation" user in the Org root account with AdministratorAccess
1. Create access keypair for the "automation" user and use it to deploy aws/org to create additional AWS OUs and Accounts
