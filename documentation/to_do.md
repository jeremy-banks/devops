[Return Home](../README.md#documentation)

## To Do
- [ ] central egress of NAT and endpoints for services
- [ ] immutable log archiving with N-day retention
- [ ] cVPN with Federated Access using Active Directory
- [ ] test Site-to-Site VPN connection between my home hardware and AWS
- [ ] Create a faux DR event by creating terraform code that blocks traffic in ACL of one AZs subnets
- [ ] Add multi-region active-active Postgres to EKS deployments
- [ ] Mozilla Secrets OPerationS (SOPS) implementation to keep secrets protected
- [ ] Implement StackSet Deployments

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

- Centralized logging with compression and glacier archive
   - DNS logs sent to CloudWatch Log Group and S3 (with cross-regional replication and glacier)
   - ALB logs send to CloudWatch Log Group and S3 (with cross-regional replication and glacier)
