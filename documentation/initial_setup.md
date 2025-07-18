[Return Home](../README.md#documentation)

# Initial Setup

## Prerequisites
- aws-cli/2.27.52
- Terraform v1.12.2
- eksctl version 0.210.0
- kubectl v1.33.3
- helm v3.18.4

## Instructions

### Update terraform/variables.tf with Your Unique Information
1. Create an email address, ideally a mailbox shared by senior engineers, to use as org owner
   1. `org_owner_email_prefix` "jeremybankstech+newtestbed" and `org_owner_email_domain_tld` "gmail.com"
1. Add your company information
   1. `company_name` "microsoft" and `company_name_abbr` "ms"
   1. `team_name` "blue" and `team_name_abbr` "blu"
   1. `project_name` "windows13" and `project_name_abbr` "w13"
   1. `cost_center` for billing
1. Enable Failover Region
   1. `create_failover_region` (true|false)
1. Declare your Region(s)
   1. `region.primary` "us-west-2" and `region.primary_short` "usw2"
   1. `region.failover` "us-east-1" and `region.failover_short` "use1"
1. Explicitly defined availability zones limit network traffic and reduce costs
   1. `azs_used` 2-4
   1. `azs_primary` ["usw2-az1","usw2-az2","usw2-az3"]
   1. `azs_failover` ["use1-az1","use1-az2","use1-az3"]

### Deploy Org Management / Root Account
1. Create AWS Account to be Org Management / Root
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

### Deploy OUs, Accounts, and SCPs
1. Deploy `terraform/aws/ous-scps-and-accounts`
1. Update the terraform/variables.tf `account_id` map with the output
1. Increase max number of accounts
   1. In AWS Console, navigate to Service Quotas -> AWS services -> AWS Organizations
   1. Request `Default maximum number of accounts` to 100

### Deploy IAM Groups and Roles
1. Deploy `terraform/aws/iam`
1. Create AWS CLI profile named "admin" with the output
   ```sh
   terraform output -json
   aws configure --profile admin
   ```

### Deploy Networking
1. Deploy `terraform/aws/networking`

### Deploy Workload Spoke A
1. Deploy `terraform/aws/workload-spoke-a-prd`

### Desploy EKS in 
1. Update eksctl/sdlc-prd-blue.yaml and eksctl/sdlc-prd-failover-blue.yaml with vpc_id and private_subnets for primary and failover from terraform output of workload-spoke-a-prd
1. Deploy eksctl/blue.yaml
   1. Assume admin role in account
      ```sh
      # replace 012345678912 with the account id
      AWS_PROFILE=admin aws sts assume-role \
         --role-arn arn:aws:iam::012345678912:role/admin \
         --role-session-name workload-spoke-a-prd \
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

### Deploy Workload Spoke B (Optional)
1. Deploy `terraform/aws/workload-spoke-a-prd`