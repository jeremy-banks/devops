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
- AWS cli 2.17.48
- Terraform v1.9.5
<!-- - SOPS 3.8.1 -->
- eksctl 0.173.0
- kubectl v1.29.2
<!-- - Terraform state and SOPS backend resources (S3 bucket, DynamoDB, and CMK)
  Terraform should _use_ entirely separate infrastructure from what Terraform _manages_, eg best practice is to provision Terraform backend resources in a completely separate AWS Org and Account -->

## Initial Setup
1. Create AWS Account to be Organization root
1. Create non-Console IAM user named "superadmin" and attach AdministratorAccess policy
   1. Create an Access Key/Secret to be used in AWS CLI profile named "superadmin"
   1. Update the terraform/variables.tf with your unique information
      1. company_name (Microsoft)
      1. company_email_prefix (billg)
      1. company_email_domain (microsoft.com)
      1. company_domain (windows.com)
      1. team_name (Blue)
      1. project_name (Windows 13)
<!-- 1. Deploy terraform/aws/tfstate-backend
   1. Update the terraform/aws/*/backend.tf files with:
      1. org root account id   find . -name 'backend.tf' -exec sed -i 's/TFSTATEBACKENDORGACCOUNTID/123456789012/g' {} +
      1. bucket:  find . -name 'backend.tf' -exec sed -i 's/TFSTATEBACKENDS3BUCKETNAME/tfstate-bucket-name/g' {} +
      1. dynamodb table:  find . -name 'backend.tf' -exec sed -i 's/TFSTATEBACKENDDYNAMODBTABLE/dynamodb-tfstate-lock/g' {} + -->
1. Deploy terraform/aws/org-ou-account-management to create additional AWS Organization Units and Accounts
   1. Update the terraform/variables.tf account_numbers map with the output
1. Deploy terraform/aws/iam-groups-and-roles
   1. Create a new AWS CLI profile named "automation" with terraform output
   ```sh
   terraform output -json
   aws configure --profile automation
1. Deploy terraform/aws/r53-zones-and-records
   1. Update your domain registrar with the output nameservers
1. Deploy terraform/aws/tgw-and-shared-vpc
1. Deploy terraform/aws/enterprise-ad
   1. This deployment can take up to 2 hours and may fail several times due to AWS throttling, keep running plan and apply until complete
   1. Update the terraform/variables.tf ad_directory_id string, ad_directory_id_connector_network string, and ad_directory_id_connector_network_failover string with the output
1. Deploy terraform/aws/client-vpn
1. Deploy terraform/aws/project-demo-nonprod
<!-- 1. Deploy terraform/aws/project-demo-prod -->
1. Deploy EKS cluster via eksctl
   1. eksctl create cluster -f eksctl/blue.yaml
   1. eksctl delete cluster --name blue
   1. eksctl create nodegroup --cluster blue --name=general
   1. eksctl delete nodegroup --cluster blue --name=general
<!-- 1. YOU ARE HERE -->
1. Deploy cluster-services via helm
   1. CNI
   1. externalDNS
   1. ALB controller
   1. Cluster Autoscaler Horiz + Vert
1. Deploy nginx via helm
   1. Basic welcome page

## To-Do
- move desired R53 healthcheck source locations to a var and local design
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
- Implement backend tfstate lock with dynamodb
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
