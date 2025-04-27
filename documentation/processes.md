[Return Home](../README.md#documentation)

# Processes

## Account Management

### Accessing Accounts
superadmin user assumes superadmin roles and manages
    the Organization
    top-level OUs
    all resources in Foundational OUs
    IAM and other security resources in all accounts
    superadmin allowed to assume all roles
admin user assumes admin roles and manages resources in Additional OUs
admin-STRING optional user assumes admin-STRING role for managing resources in strict-access OUs
breakglass1, 2, 3 users have same access as superadmin in event of IDP failure


Create New Workload Account
1. deploy new account
   1. copy ou-workloads-spoke-example into a new directory
   1. replace providers with new account into
   1. Create new strings in the lists `account_email_slug`, `account_email_substitute`, `vpc_cidr_infrastructure`
   1. update account id in variable ``
1. deploy new iam roles
1. deploy infra

### Replacing an Account
1. Remove old Account from tfstate
   - `terraform state rm aws_organizations_account.RESOURCE`
1. Update email of old Account
   - https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-update-root-user-email.html#root-user-email-orgs
   - `AWS_PROFILE=superadmin aws account start-primary-email-update --account-id OLD_ACCOUNT_NUMBER --primary-email NEW_EMAIL`
   1. Confirm email change with OTP
   - `AWS_PROFILE=superadmin aws account accept-primary-email-update --account-id OLD_ACCOUNT_NUMBER --otp EMAILED_OTP --primary-email NEW_EMAIL`
1. Let Terraform recreate the Account
   - `terraform apply`
   1. Verify newly created account is in scope
1. Move old Account into Suspended OU
   1. Close old Account
