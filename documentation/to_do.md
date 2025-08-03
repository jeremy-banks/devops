[Return Home](../README.md#documentation)

# To-Do
- rework the eks stuff
   append k8s 'bare metal' to demonstrate skill and pass CKA

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
