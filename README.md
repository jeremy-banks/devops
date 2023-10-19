# Devops

## Description
Base level deployment AWS resources required to host an EKS cluster.

## Prerequisites
- AWS cli 2.13.26
- Terraform v1.6.1
- eksctl
- kubectl

This demo uses a single aws account, an IAM role with admin rights, and an IAM user with the rights to assume that role. Since this is just a demo, nonprod and prod share the same account and are separated by region.

## Features
- IAM roles restrict non-readonly actions on all resources provisioned by IaC (enforced by tag)
- Terraform split into several smaller repos: smaller blast radius and faster time to complete

## Terraform
Security
    Account Settings
        EBS encryption
        S3 public disabled
        Default credit specification: standard
    IAM Groups
Ancillary
    R53
    ACM
    KMS
    S3 flow logs
    S3 alb logs
IAM Users
VPC
Storage
    RDS
    S3