# Devops

## Description
AWS resources required to host an EKS cluster.

## Prerequisites
- AWS cli 2.13.26
- Terraform v1.6.1
- eksctl
- kubectl
- terraform backend resources (s3 bucket, dynamodb, and cmk)

This demo uses a single aws account, an IAM role with admin rights, and an IAM user with the rights to assume that role. Since this is just a demo, nonprod and prod share the same account and are separated by region.

## Tools

### Terraform

#### Repo Layout
1. 0-acct-sec
..* Cost savings by disabling Unlimited credits for burstable instance types
..* EBS volume encryption at rest enabled by default
..* S3 public access blocked by account
..* IAM Groups and Policies
2. Undefined
..* Undefined

Security
  Account Settings
      EBS encryption
      S3 public disabled
      Default burstable credit specification: standard
  IAM Groups and Policies
  ACM
  KMS

Ancillary
  R53
  S3 flow logs
  S3 alb logs
IAM Users
VPC
Storage
  RDS
  S3

### EKS
