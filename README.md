# DevOps

## Project Goals
1. Create my ideal codebase to "lift and shift" a startup or small organization into AWS and EKS
1. Using minimal number tools with high market share utilization (eg terraform, eksctl, helm)
1. Demo with k8s nginx welcome page

### Documentation Reference
- Terraform providers and modules all version locked
- Code written following AWS documentation
  - Guidance to Render Unsecured PHI Unusable https://www.hhs.gov/hipaa/for-professionals/breach-notification/guidance/index.html
  - Well-Architected Framework  https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html
  - Prescriptive Guidance Security Reference Architecture https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/org-management.html
  - Best practices for multi-account management https://docs.aws.amazon.com/organizations/latest/userguide/orgs_best-practices.html
  - Building a Scalable and Secure Multi-VPC AWS Network Infrastructure https://docs.aws.amazon.com/whitepapers/latest/building-scalable-secure-multi-vpc-network-infrastructure/welcome.html
  - Latencies between AWS availability zones https://www.flashgrid.io/news/latencies-between-aws-availability-zones-what-are-they-and-how-to-minimize-them

## Architectural Overview

### Org and Accounts
<p align="center"><img src="drawings/org-and-account-layout.drawio.png"/></p>

The organization, organization units, and accounts layout is designed in accordance to the documented best practices for OUs in the [AWS Organizations User Guide](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_ous_best_practices.html). This codebase is can be expanded to accommodate additional OUs such as Sandbox, Suspended, Exceptions, etc.

### VPC Options

#### Failover

| Failover Enabled | Failover Disabled |
| :-: | :-: |
| <img src="drawings/vpc-layout-failover.drawio.png" width="400"/> | <p align="center"><img src="drawings/vpc-layout.drawio.png" width="400"/> |

The Virtual Private Cloud and Transit Gateway layout is designed in accordance to the Hub and Spoke model in the [Building a Scalable and Secure Multi-VPC AWS Network Infrastructure Whitepaper](https://docs.aws.amazon.com/whitepapers/latest/building-scalable-secure-multi-vpc-network-infrastructure/transit-gateway.html).

- Service Endpoints are shared to the entire Organization through the Network VPCs and Transit Gateways
- Private R53 zone `internal.` is attatched to the Network VPCs providing standard human-readable DNS for the Endpoints
- SDLC Accounts have Network VPC shared to keep down cost

##### Options

| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| `availability_zones_num_used` | number | 2 | Number of availability zones used in the VPCs for this account, codebase supports 2-6. |
| `network_tgw_share_enabled` | boolean | `false` | Network TGW will be shared to this account. |
| `network_vpc_endpoint_services_enabled` | list(string) | `[""]` | Which endpoint services are attached to the Network VPC and shared through the TGW. |
| `network_vpc_share_enabled` | boolean | `false` | Network VPC will be shared to this account. |
| `vpc_cidr_substitute` | string | `""` | A VPC will be provisioned in the Primary region with the specified CIDR. |
| `vpc_cidr_substitute_failover` | string | `""` | A VPC will be provisioned in the Failover region with the specified CIDR. |

In the Failover Enabled diagram above the following options are defined:

| Account | Options |
| --- | --- |
| Network | `network_vpc_endpoint_services_enabled`, `vpc_cidr_substitute`, `vpc_cidr_substitute_failover` |
| SDLC | `network_vpc_share_enabled` |
| CustomerA | `network_tgw_share_enabled`, `vpc_cidr_substitute`, `vpc_cidr_substitute_failover` |
| CustomerB | `network_tgw_share_enabled`, `vpc_cidr_substitute` |
| CustomerC |  |

In the Failover Disabled diagram above the following options are defined:

| Account | Options |
| --- | --- |
| Network | `network_vpc_endpoint_services_enabled`, `vpc_cidr_substitute` |
| SDLC | `network_vpc_share_enabled` |
| CustomerA | `network_tgw_share_enabled`, `vpc_cidr_substitute` |
| CustomerB | `network_tgw_share_enabled`, `vpc_cidr_substitute` |
| CustomerC |  |

## Initial Setup

### Prerequisites
- aws-cli/2.17.65
- Terraform v1.9.7
- eksctl version 0.191.0
- kubectl v1.31.1
- helm v3.16.1

### Instructions

#### Deploy Backend and Create Org
1. Create AWS Account to be Organization root
   1. During account creation be sure to enable Developer tier AWS Support, you will need to open a Support Case for increasing your quote of `Default maximum number of accounts`.
1. Update the terraform/variables.tf with your unique information
   1. `org_owner_email_prefix` (billg) and `org_owner_email_domain_tld` (microsoft.com)
   1. `company_name` (microsoft) and `company_name_abbr` (ms)
   1. `team_name` (blue) and `team_name_abbr` (blu)
   1. `project_name` (windows13) and `project_name_abbr` (w13)
1. Create IAM User "superadmin"
   1. Attach AdministratorAccess policy
   1. Create an access key to be used in AWS CLI profile named "superadmin"
      ```sh
      aws configure --profile superadmin
      ```
1. Deploy `terraform/aws/management-account`
1. Update the backend.tf files in `terraform/aws/` and subdirectories
   ```sh
   find . -name 'backend.tf' -exec sed -i 's,TFSTATEBACKENDORGACCOUNTID,600627360992,g' {} + &&\
   find . -name 'backend.tf' -exec sed -i 's,TFSTATEBACKENDREGION,us-west-2,g' {} + &&\
   find . -name 'backend.tf' -exec sed -i 's,TFSTATEBACKENDDYNAMODBTABLE,scc-blu-w12-usw2-tfstate,g' {} + &&\
   find . -name 'backend.tf' -exec sed -i 's,TFSTATEBACKENDKMSARN,arn:aws:kms:us-west-2:600627360992:key/mrk-e42ea270137a4b6e9cea326d5435e5c2,g' {} + &&\
   find . -name 'backend.tf' -exec sed -i 's,TFSTATEBACKENDS3BUCKETNAME,scc-blu-w12-usw2-tfstate-storage-blob-569d758c,g' {} +
   ```
1. Uncomment `terraform/aws/management-account/backend.tf` and migrate state with `echo yes | terraform init -reconfigure`
1. Open Support Case with Account and Billing in the Organization requesting `Default maximum number of accounts` increased to `1000`.

#### Deploy Org
1. Deploy terraform/aws/org-ous-and-accounts to create additional AWS Organization Units and Accounts
   1. Update the terraform/variables.tf account_id map with terraform output
1. Deploy terraform/aws/iam-groups-and-roles
   1. Create AWS CLI profile named "automation" with terraform output
      ```sh
      terraform output -json
      aws configure --profile automation
      ```

#### Deploy Transit Gateway and Shared Network VPC
1. Deploy terraform/aws/tgw-and-network-vpc
1. Deploy sdlc accounts
   1. Deploy terraform/aws/sdlc-prd
      1. Update eksctl/sdlc-prd-blue.yaml and eksctl/sdlc-prd-failover-blue.yaml with vpc_id and private_subnets for primary and failover from terraform output
   1. Deploy eksctl/blue.yaml
      1. Assume automation role in account
         ```sh
         # replace 012345678912 with the account id
         AWS_PROFILE=automation aws sts assume-role \
            --role-arn arn:aws:iam::012345678912:role/automation \
            --role-session-name sdlc-session \
            --duration-seconds 36000
         # replace foo, bar, and helloworld with matching outputs
         export AWS_ACCESS_KEY_ID=foo
         export AWS_SECRET_ACCESS_KEY=bar
         export AWS_SESSION_TOKEN=helloworld
         unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
         ```
      1. Deploy Cluster
         Update the vpc-id and subnet-ids in blue.yml
         ```sh
         eksctl create cluster -f blue.yml &
         eksctl delete cluster --name scc-blue-w12-usw2-blue --region us-west-2 &
         eksctl create nodegroup -f blue.yml &
         eksctl delete nodegroup --cluster scc-blue-w12-usw2-blue --name general --region us-west-2 &
         ```
      1. Deploy cluster-services
         ```sh
         helm upgrade --install cluster-services . --namespace kube-system --force &
         helm uninstall cluster-services --namespace kube-system &
         ```
      1. Deploy nginx welcome page
         ```sh
         helm upgrade --install nginx-welcome bitnami/nginx -f values.yaml --force &
         helm uninstall nginx-welcome &
         ```
         1. Great for troubleshooting deployments
            ```sh
            for i in $(seq 1 30); do helm upgrade --install nginx-welcome$i bitnami/nginx; done &
            for i in $(seq 1 30); do helm uninstall nginx-welcome$i bitnami/nginx; done &
            ```
      1. Test your website
         ```sh
         curl www.yourwebsite.com
         ```
   1. Deploy terraform/aws/sdlc-tst
   1. Deploy terraform/aws/sdlc-stg
   1. Deploy terraform/aws/sdlc-prd
<!-- 1. Deploy terraform/aws/enterprise-ad
   1. This deployment can take up to 2 hours and may fail several times due to AWS throttling, keep running plan and apply until complete
   1. Update the terraform/variables.tf ad_directory_id_connector_network and ad_directory_id_connector_network_failover strings with terraform output
1. Deploy terraform/aws/client-vpn -->
<!-- 1. Deploy customer accounts
   1. Deploy terraform/aws/workload-customera
   1. Deploy terraform/aws/workload-customerb -->

## To-Do
- SCP enforcing features
   - S3 buckets never public
   - aws_ebs_snapshot_block_public_access
   - block public s3 access
- Complete sdlc dev, tst, and stg
   - need to expand IAM into new customer accounts and SDLC
   - need to share network VPC to sdlc
      - need code for share_vpc and share_tgw
   - sdlc needs an elegant way to create DNS records to point to VPC endpoints in the shared network VPC
      - needs to support multi-regional failover as well
      - just start with making R53 entries first, this may be all that is needed
- Federated login for devops, operations, and developers
   - https://getstarted.awsworkshop.io/02-dev-fast-follow/02-federated-access-to-aws/02-aws-sso-ad.html
   - https://aws.amazon.com/blogs/architecture/field-notes-integrating-active-directory-federation-service-with-aws-single-sign-on/
   - Also need Windows Admin Server in some account
   - Goal is to have everyone log in to SSO and their priviledges to log in and assume roles will dynamically populate based on their groups in AD
   - might need to make a separate DOMAIN.TLD for services like clientVPN and enterprise AD domains if any
- Triggering a DR event
   - ACL allows no traffic in one subnet
   - EKS autoscaling examples
      - CPU
      - Sessions
- Implement the Well-Architected Tool https://docs.aws.amazon.com/whitepapers/latest/organizing-your-aws-environment/organizing-your-aws-environment.html
- Base docker images for all distros
   - initially just docker images which run apt-get upgrade or yum upgrade to get patches
- Implement Rust server
- Complete some kind of automation to convert drawings into png for this documentation
- Centralized logging with compression and glacier archive
   - DNS logs sent to CloudWatch Log Group and S3 (with cross-regional replication and glacier)
   - ALB logs send to CloudWatch Log Group and S3 (with cross-regional replication and glacier)
- AD
   - Update directory AD and client VPN so groups in AD manage network access to AWS environments
   - Add Windows Server 2019 cheap instance to Directory for AD administration
- StackSet Deployments
   - Disable unlimited burstable instance credits
   - delete all default VPCs in all regions of every account
   - AWS config for hipaa, CIS, NIST
      - aggregate to security account probably
   - AWS Backup with Multi-AZ and glacier
- Mozilla Secrets OPerationS (SOPS) protects secrets in code using Key Management System (KMS) Customer Managed Key (CMK)
- break glass entry for accounts https://docs.aws.amazon.com/whitepapers/latest/organizing-your-aws-environment/break-glass-access.html
- ALB sec group with cool way of allowing ingress (nonprod through private CVPN, prod through public)
- MFA enforced organization-wide

## Known Issues
- terraform/aws/org-ous-and-accounts/main.tf
  resource "aws_servicequotas_service_quota" "ACCOUNT_NUMBER_LIMIT_EXCEEDED"
  https://github.com/hashicorp/terraform-provider-aws/issues/32638
  In the meantime request quota increases manually
