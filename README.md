# Devops

## Description
Codebase for provisioning managed kubernetes (k8s) using infrastructure as code.

### Features
- Terraform modules all version locked
- Mozilla SOPS protects secrets in code using kms

#### AWS
- Code written following AWS Prescriptive Guidance Security Reference Architecture https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/org-management.html
- Resources are protected by Permission Boundary using tags
- MFA enforced organization-wide
- DNS logs sent to CloudWatch Log Group and S3 (cross-regional replication, glacier)

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
1. Create single AWS Account to be the Organization root
1. Create non-Console IAM user "automation", attach AdministratorAccess, and create an Access Key
1. Deploy aws/org-ou-account-management to create additional AWS OUs and Accounts
1. Update the variables.tf account_numbers map with the newly created Account numbers
1. Deploy aws/org-iam-groups-and-roles
1. Deploy aws/network-r53
