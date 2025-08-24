terraform {
  backend "s3" {
    profile      = "superadmin"
    region       = "tfstate_region"
    bucket       = "tfstate_s3_bucket_name"
    key          = "superadmin/central-r53"
    use_lockfile = true
    insecure     = false
    encrypt      = true
    kms_key_id   = "tfstate_kms_arn"
  }
}