[Return Home](../README.md#documentation)

# Processes

## Account Management

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
