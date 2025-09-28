terraform {
  backend "s3" {
    profile      = "superadmin"
    region       = "us-west-2"
    bucket       = "gn-devops-aftb-prd-usw2-tfstate-e78b50"
    key          = "superadmin/workload-product-a-prd"
    use_lockfile = true
    insecure     = false
    encrypt      = true
    kms_key_id   = "arn:aws:kms:us-west-2:134857759269:key/mrk-43d0394bc5a64c538f3f7c2bb5f879e6"
  }
}