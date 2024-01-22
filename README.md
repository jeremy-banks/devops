# Devops

## Goal of this Project
Codebase for provisioning managed Kubernetes (EKS) and all surrounding AWS resources using only terraform, eksctl, and helm

## Features
- Terraform providers and modules all version locked
- All resources which support multi-regional have it enabled in active-active (or at least active-passive)
- AWS IAM Permission Boundary in effect, preventing all editing of terraformed resources by non-terraform roles
- Terraform does not manage resources it uses to access provisioning
  - superadmin role is used to manage automation, admin, poweruser, readonly, and eks roles
  - every other resource is managed by automation role
- MFA enforced organization-wide
- Code written following AWS documentation
  - Well-Architected Framework  https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html
  - Prescriptive Guidance Security Reference Architecture https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/org-management.html
  - Best practices for multi-account management https://docs.aws.amazon.com/organizations/latest/userguide/orgs_best-practices.html
  - Building a Scalable and Secure Multi-VPC AWS Network Infrastructure https://docs.aws.amazon.com/whitepapers/latest/building-scalable-secure-multi-vpc-network-infrastructure/welcome.html
  - Latencies between AWS availability zones https://www.flashgrid.io/news/latencies-between-aws-availability-zones-what-are-they-and-how-to-minimize-them

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
1. Create non-Console IAM user named "superadmin" with AdministratorAccess
   1. Create an Access Key/Secret to be used in AWS CLI profile named "superadmin"
   1. Update the terraform/variables.tf company_domain variable
1. Deploy terraform/aws/org-ou-account-management to create additional AWS Organization Units and Accounts
   1. Update the terraform/variables.tf account_numbers map with the output Account ID numbers
1. Deploy terraform/aws/iam-groups-and-roles
   1. Create a new AWS CLI profile named "automation" with output of terraform
1. Deploy terraform/aws/r53-zones-and-records
   1. Update your domain registrar with the output nameservers
1. Deploy terraform/aws/tgw-and-shared-vpc
1. Deploy terraform/aws/enterprise-ad
   1. Updated the terraform/variables.tf shared_ad_directory_id string with the output Directory ID
1. Deploy terraform/aws/client-vpn
1. Deploy terraform/aws/project-demo-nonprod
### You are here
<!-- 1. Deploy terraform/aws/project-demo-prod -->
1. Deploy EKS cluster via eksctl
1. Deploy cluster-services via helm
   1. CNI
   1. externalDNS
   1. ALB controller
   1. Cluster Autoscaler Horiz + Vert
1. Deploy nginx via helm
   1. Basic welcome page

## To-Do
- move desired R53 healthcheck source locations to a var and local design
- Share the Shared Directory to all OUs except workloads
- Update directory AD and client VPN so groups in AD manage network access to AWS environments
- Add Windows Server 2019 cheap instance to Directory for AD administration
- Create truncated resource stub for those few resources with limited characters in names
  - remove all vowels except for first character of each word
  - replace spaces with dashes
  - truncate each input by local.trimmed_length
  - lowercase
- ALB sec group with cool way of allowing ingress (nonprod through private CVPN, prod through public)
- AWS Backup with Multi-AZ and glacier
- Multi-AZ storage active-active if possible
  - s3
  - rds
  - efs
- EKS autoscaling examples
  - CPU
  - Sessions
- Triggering a DR event
- Implement backend tfstate and lock
- Mozilla Secrets OPerationS (SOPS) protects secrets in code using Key Management System (KMS) Customer Managed Key (CMK)
- Centralized logging with compression and glacier archive
  - DNS logs sent to CloudWatch Log Group and S3 (with cross-regional replication and glacier)
  - ALB logs send to CloudWatch Log Group and S3 (with cross-regional replication and glacier)
- SCP enforcing features
  - EBS volume encryption
  - S3 buckets never public
  - Disable unlimited burstable instance credits
  - delete all default VPCs in all regions of every account

## Known Issues
- terraform/aws/org-ou-account-management/main.tf
  resource "aws_servicequotas_service_quota" "ACCOUNT_NUMBER_LIMIT_EXCEEDED"
  https://github.com/hashicorp/terraform-provider-aws/issues/32638
  In the meantime request quota increases manually
