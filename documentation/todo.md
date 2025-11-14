[Return Home](../README.md#documentation)

# To-Do
- central endpoints
- Centralized logging with compression and glacier archive
   - DNS logs sent to CloudWatch Log Group and S3 (with cross-regional replication and glacier)
   - ALB logs send to CloudWatch Log Group and S3 (with cross-regional replication and glacier)
- monitoring (open source)
- central egress of NAT and endpoints for services
- immutable log archiving with N-day retention
- cVPN with Federated Access using Active Directory
- test Site-to-Site VPN connection between my home hardware and AWS
- implement r53 resolver
- Create a faux DR event by creating terraform code that blocks traffic in ACL of one AZs subnets
- Add multi-region active-active Postgres to EKS deployments
- Mozilla Secrets OPerationS (SOPS) implementation to keep secrets protected
- Implement StackSet Deployments
   - Disable unlimited burstable instance credits
   - delete all default VPCs in all regions of every account
   - AWS config for hipaa, CIS, NIST
      - aggregate to security account probably
   - AWS Backup with Multi-AZ and glacier
   - MFA enforced organization-wide