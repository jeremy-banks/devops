terraform {
  backend "s3" {
    profile      = "superadmin"
    insecure     = false
    region       = "us-west-2"
    bucket       = "pc-devops-ntb-usw2-tfstate-storage-blob-516d6b68"
    key          = "superadmin/management-account"
    encrypt      = true
    kms_key_id   = "arn:aws:kms:us-west-2:387387300418:key/mrk-8f857bc1b9d5488d848911a744543d81"
    use_lockfile = true
  }
}