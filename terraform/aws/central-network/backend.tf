terraform {
  backend "s3" {
    bucket       = "tfstate_s3_bucket_name"
    region       = "tfstate_region"
    kms_key_id   = "tfstate_kms_arn"
    profile      = "superadmin"
    key          = "superadmin/central-network"
    use_lockfile = true
    insecure     = false
    encrypt      = true
  }
}