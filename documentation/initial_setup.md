[Return Home](../README.md#documentation)

# Initial Setup

## Prerequisites
- aws-cli/2.25.5
- Terraform v1.11.3
- eksctl version 0.191.0
- kubectl v1.31.1
- helm v3.16.1

## Instructions

### Deploy Org Management / Root Account
1. Create AWS Account to be Org Management / Root
   1. During account creation enable Developer tier AWS Support.
1. Update the terraform/variables.tf with your unique information
   1. `org_owner_email_prefix` (billg) and `org_owner_email_domain_tld` (microsoft.com)
   1. `company_name` (microsoft) and `company_name_abbr` (ms)
   1. `team_name` (blue) and `team_name_abbr` (blu)
   1. `project_name` (windows13) and `project_name_abbr` (w13)
   1. `cost_center` for billing
1. Create IAM User "superadmin"
   1. Attach AdministratorAccess policy
   1. Create an access key and AWS CLI profile named "superadmin" `aws configure --profile superadmin`
1. Deploy `terraform/aws/management-account`
1. Update the backend.tf files in `terraform/aws/` and subdirectories
   ```sh
   find . -name 'backend.tf' -exec sed -i '' 's,TFSTATEBACKENDORGACCOUNTID,012345678912,g' {} + &&\
   find . -name 'backend.tf' -exec sed -i '' 's,TFSTATEBACKENDREGION,us-west-2,g' {} + &&\
   find . -name 'backend.tf' -exec sed -i '' 's,TFSTATEBACKENDDYNAMODBTABLE,scc-blu-w12-usw2-tfstate,g' {} + &&\
   find . -name 'backend.tf' -exec sed -i '' 's,TFSTATEBACKENDKMSARN,KEY_ARN,g' {} + &&\
   find . -name 'backend.tf' -exec sed -i '' 's,TFSTATEBACKENDS3BUCKETNAME,scc-blu-w12-usw2-tfstate-storage-blob-569d758c,g' {} +
   ```
1. Uncomment `terraform/aws/management-account/backend.tf` and migrate state with `terraform init -force-copy`
1. Open a `Chat` AWS Support Case with `Account and Billing` in category `Organization` requesting `Default maximum number of accounts` increased to `1000`.

### Deploy OUs, Accounts, and SCPs
1. Deploy `terraform/aws/ous-and-accounts`
1. Update the terraform/variables.tf `account_id` map with the output

### Deploy IAM Groups and Roles
1. Deploy `terraform/aws/iam`
1. Create AWS CLI profile named "automation" with the output
   ```sh
   terraform output -json
   aws configure --profile automation
   ```

### Deploy Transit Gateway and Shared Network VPC
1. Deploy `terraform/aws/network`
   1. Uncomment ???
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
