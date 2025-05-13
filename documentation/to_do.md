[Return Home](../README.md#documentation)

# To-Do
- get a job because this repo isn't cheap to develop

- 'sharing' public subnets from inbound VPC in networking account so k8s in spokes can make and/or manipulate ALBs

- outbound endpoints for s3, kms, rds so that all org traffic to those services is privately routes for security and cost savings

- rework the eks stuff
   append k8s 'bare metal' to demonstrate skill and pass CKA

- impelement federated access using active directory and windows server
   - https://getstarted.awsworkshop.io/02-dev-fast-follow/02-federated-access-to-aws/02-aws-sso-ad.html
   - https://aws.amazon.com/blogs/architecture/field-notes-integrating-active-directory-federation-service-with-aws-single-sign-on/
   - Also need Windows Admin Server in some account
   - Goal is to have everyone log in to SSO and their priviledges to log in and assume roles will dynamically populate based on their groups in AD
   - might need to make a separate DOMAIN.TLD for services like clientVPN and enterprise AD domains if any
   - AD
      - Update directory AD and client VPN so groups in AD manage network access to AWS environments
      - Add Windows Server 2019 cheap instance to Directory for AD administration

- trigger a faux DR event
   - ACL allows no traffic in one subnet
   - EKS autoscaling examples
      - CPU
      - Sessions

- Centralized logging with compression and glacier archive
   - DNS logs sent to CloudWatch Log Group and S3 (with cross-regional replication and glacier)
   - ALB logs send to CloudWatch Log Group and S3 (with cross-regional replication and glacier)

- Mozilla Secrets OPerationS (SOPS) protects secrets in code using Key Management System (KMS) Customer Managed Key (CMK)

- StackSet Deployments
   - Disable unlimited burstable instance credits
   - delete all default VPCs in all regions of every account
   - AWS config for hipaa, CIS, NIST
      - aggregate to security account probably
   - AWS Backup with Multi-AZ and glacier
   - SCP enforcing features
      - S3 buckets never public
      - aws_ebs_snapshot_block_public_access
      - block public s3 access
   - MFA enforced organization-wide