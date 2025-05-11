output "org_account_id" {
  value = data.aws_caller_identity.this.id
}

output "region" {
  value = var.region.primary
}

output "tfstate_kms_arn" {
  value = module.kms_tfstate_backend_primary.key_arn
}

output "tfstate_s3_arn" {
  value = module.s3_tfstate_backend_primary.s3_bucket_id
}

output "iam_user_admin_access_key" {
  description = "admin access key"
  value       = module.iam_user_admin.iam_access_key_id
  sensitive   = true
}

output "iam_user_admin_access_secret" {
  description = "admin access secret"
  value       = module.iam_user_admin.iam_access_key_secret
  sensitive   = true
}

output "iam_user_breakglass_credentials" {
  description = "Map of IAM usernames and passwords"
  value = { for idx, user in module.iam_user_breakglass :
    user.iam_user_name => user.iam_user_login_profile_password
  }
  sensitive = true
}