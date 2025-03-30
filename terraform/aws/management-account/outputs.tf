output "org_account_id" {
  value = data.aws_caller_identity.this.id
}

output "region" {
  value = var.region.primary
}

output "tfstate_kms_arn" {
  value = module.kms_primary.key_arn
}

output "tfstate_s3_arn" {
  value = module.s3_primary.s3_bucket_id
}

output "iam_user_admin_iam_access_key_id" {
  description = "admin access key id"
  value       = module.iam_user_admin.iam_access_key_id
  sensitive   = true
}

output "iam_user_admin_iam_access_key_secret" {
  description = "admin access key secret"
  value       = module.iam_user_admin.iam_access_key_secret
  sensitive   = true
}