# Devops

## Description
Codebase for provisioning managed kubernetes (k8s) in AWS using only terraform, eksctl, and helm.

## Features
- Terraform modules all version locked
- Secrets OPerationS (SOPS) protects secrets in code using Key Management System (KMS) Customer Managed Key (CMK)
- Code written following AWS documentation
  - Well-Architected Framework  https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html
  - Prescriptive Guidance Security Reference Architecture https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/org-management.html
  - Best practices for multi-account management https://docs.aws.amazon.com/organizations/latest/userguide/orgs_best-practices.html
- Resources are protected by Permission Boundary using tags
- MFA enforced organization-wide

## To-Do
- DNS logs sent to CloudWatch Log Group and S3 (cross-regional replication, glacier)
- SCP enforcing features
  - EBS volume encryption
  - S3 buckets never public
  - Disable unlimited burstable instance credits
- Implement backend tfstate and lock

## Known Issues
- terraform/aws/org-ou-account-management/main.tf
  resource "aws_servicequotas_service_quota" "ACCOUNT_NUMBER_LIMIT_EXCEEDED"
  https://github.com/hashicorp/terraform-provider-aws/issues/32638
  In the meantime request quota increases manually

## Prerequisites
- AWS cli 2.13.26
- Terraform v1.6.1
- SOPS 3.8.1  https://github.com/getsops/sops/releases/tag/v3.8.1
- eksctl x.x.x
- kubectl x.x.x
- Terraform state and SOPS backend resources (S3 bucket, DynamoDB, and CMK)
  Terraform should _use_ entirely separate infrastructure from what Terraform _manages_, eg best practice is to provision Terraform backend resources in a completely separate AWS Org and Account

## Initial Setup
1. Create AWS Account to be Organization root
1. Create non-Console IAM user named "superadmin" with AdministratorAccess and create an Access Key/Secret to be used in AWS CLI profile named "superadmin"
1. Deploy terraform/aws/org-ou-account-management to create additional AWS Organization Units and Accounts
1. Update the terraform/variables.tf account_numbers map with the newly created Account numbers
1. Deploy terraform/aws/iam-groups-and-roles, and create a new AWS CLI profile named "automation" with output of terraform
1. ### YOU ARE HERE

1. Deploy terraform/aws/
1. Comment out provider_role_name variable in terraform/aws/org-iam-groups-and-roles/terraform.tfvars
1. Deploy terraform/aws/terraform-framework to create resources for terraform
  1. Migrate tfstate to s3 *
  1. Update .sops.yaml with KMS ARN
  1. Update terraform/variables.tf to add sops logic
1. Deploy terraform/aws/network-r53

