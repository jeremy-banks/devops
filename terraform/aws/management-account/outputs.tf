output "tfstate_region" { value = var.region_primary.full }

output "tfstate_s3_bucket_name" { value = module.s3_tfstate_backend_primary.s3_bucket_id }

output "tfstate_kms_arn" { value = module.kms_tfstate_backend_primary.key_arn }

output "iam_user_admin_access_key" {
  value     = module.iam_user_admin.iam_access_key_id
  sensitive = true
}

output "iam_user_admin_access_secret" {
  value     = module.iam_user_admin.iam_access_key_secret
  sensitive = true
}

output "iam_user_breakglass_credentials" {
  value = { for idx, user in module.iam_user_breakglass :
    user.iam_user_name => user.iam_user_login_profile_password
  }
  sensitive = true
}