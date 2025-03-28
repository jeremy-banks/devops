output "org_account_id" {
  value = data.aws_caller_identity.this.id
}

output "region" {
  value = var.region.primary
}

output "tfstate_dynamodb_table" {
  value = module.dynamodb_primary.dynamodb_table_id
}

output "tfstate_kms_arn" {
  value = module.kms_primary.key_arn
}

output "tfstate_s3_arn" {
  value = module.s3_primary.s3_bucket_id
}