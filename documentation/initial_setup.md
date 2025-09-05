[Return Home](../README.md#documentation)

# Initial Setup

## Prerequisites
- aws-cli/2.27.52
- Terraform v1.12.2
- eksctl version 0.210.0
- kubectl v1.33.3
- helm v3.18.4

## Instructions

### High-Level Overview
Make an email, update relevant files with your unique information, and begin deploying!

### Update terraform/variables.tf with Your Unique Information
1. Create an email address to use as org owner
   1. Ideally this mailbox should be shared by senior engineers
   1. `org_owner_email_prefix` "jeremybankstech"
   1. `org_owner_email_plus_address` "awscloud"
   1. `org_owner_email_domain_tld` "gmail.com"
1. Add your company information
   1. `company_name` "photon craze" and `company_name_abbr` "pc"
   1. `team_name` "devops" and `team_name_abbr` "devops"
   1. `project_name` "newtestbed" and `project_name_abbr` "ntb"
   1. `cost_center` for billing
1. Declare use of Failover Region and the Region(s) to use
   1. `create_failover_region_network` creates tgw and central network vpcs in failover region
   1. `create_failover_region` creates workload vpcs in failover region
   1. `region_primary.full` "us-west-2" and `region_primary.short` "usw2"
   1. `region_failover.full` "us-east-1" and `region_failover.short` "use1"
1. Explicitly defined availability zones limit network traffic and reduce costs
   1. `azs_number_used_network` number of AZs for the central network to use
   1. `azs_number_used` number of AZs for workloads to use
   1. `azs_primary` ["usw2-az1","usw2-az2","usw2-az3"]
   1. `azs_failover` ["use1-az1","use1-az2","use1-az3"]

### Deploy Org Management / Root Account
1. Create AWS Account to be Root and Org Management
   1. The root user has the absolute highest authority in the organization. It should be:
      1. Assigned MFA
      1. Never given security credentials
      1. Only shared with principal engineers to reduce blast radius
      1. Used only in the event that `breakglass` user access has failed
1. Create AWS CLI User `superadmin`
   1. Attach AdministratorAccess policy
   1. Create an access key and AWS CLI profile named superadmin `aws configure --profile superadmin`
   1. These same credentials should be used to create a superadmin profile for CI/CD
1. Deploy `terraform/aws/management-account`
1. Enable Terraform State Backend
   1. Use the `terraform output` to update the backend.tf files in `terraform/aws/` and subdirectories
      ```sh
      find . -name 'backend.tf' -exec sed -i '' 's,tfstate_kms_arn,output,g' {} + &&\
      find . -name 'backend.tf' -exec sed -i '' 's,tfstate_region,output,g' {} + &&\
      find . -name 'backend.tf' -exec sed -i '' 's,tfstate_s3_bucket_name,output,g' {} +
      ```
   1. Uncomment `terraform/aws/management-account/backend.tf` and migrate state with `terraform init -force-copy`
1. Save `breakglass` user information
   1. Use `terraform output -json` to reveal passwords for the three breakglass users
   1. Save the credentials in a LastPass or other secured location
   1. breakglass users should:
      1. Never be given security credentials
      1. Only be shared with principal engineers
      1. Used only in the event that `superadmin` and `admin` access has failed
1. Create CI/CD CLI Profile `admin`
   1. Use the `terraform output -json` to create CI/CD profile named admin for non-superadmin operations
1. Increase max number of accounts
   1. In AWS Console, navigate to Service Quotas -> AWS services -> AWS Organizations
   1. Request `Default maximum number of accounts` to 100

### Deploy OUs, Accounts, and SCPs
1. Deploy `terraform/aws/ous-scps-and-accounts`
1. Update the terraform/variables.tf `account_id` map with the output

### Deploy Central R53
1. Deploy `terraform/aws/central-r53-and-acm`

### Deploy Central Network
1. Deploy `terraform/aws/central-network`

### Deploy IAM Resources
1. Deploy `terraform/aws/iam`

### Deploy Central Backup
1. Deploy `terraform/aws/central-archive`

### Deploy Workload Product A
1. `create_failover_region` used to declare whether this deployment should have a failover region
1. `azs_number_used` 2-4
1. `create_vpc_public_subnets`
1. Deploy `terraform/aws/workload-product-a-prd`

### Deploy EKS in Workload Product A
1. Update deployment files with relevant outputs
   1. `eksctl/blue.yaml` and `eksctl/green.yaml` with `kms_arn_primary`, `vpc_id_primary`, `vpc_private_subnets_ids_primary`, `vpc_security_group_id_ingress_primary`, and `vpc_security_group_id_main_primary`
   1. `helm/cluster-services/values.yaml` with `acm_arn_primary`
   1. `helm/nginx-welcome-example/values.yaml` with `acm_arn_primary`, and `workload_fqdn`
1. Deploy `eksctl/blue.yaml`
   1. Assume admin role in account
      ```sh
      # replace 012345678912 with the account_id
      AWS_PROFILE=admin aws sts assume-role \
         --role-arn arn:aws:iam::012345678912:role/admin \
         --role-session-name workload-product-a-prd \
         --duration-seconds 36000
      # replace foo, bar, and helloworld with matching outputs
      export AWS_ACCESS_KEY_ID=foo
      export AWS_SECRET_ACCESS_KEY=bar
      export AWS_SESSION_TOKEN=helloworld
      unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
      ```
   1. Deploy Cluster
      ```sh
      eksctl create cluster -f blue.yml &
      eksctl delete cluster --name blue --region us-west-2 &
      eksctl create nodegroup -f blue.yml &
      eksctl delete nodegroup --cluster blue --name general --region us-west-2 &
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
      curl workload_fqdn
      ```

### Deploy Workload Product B (Optional)
1. Deploy `terraform/aws/workload-product-a-prd`