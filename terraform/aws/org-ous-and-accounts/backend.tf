terraform {
  backend "s3" {
    profile         = "superadmin"
    insecure        = false
    region          = "TFSTATEBACKENDREGION"
    bucket          = "TFSTATEBACKENDS3BUCKETNAME"
    key             = "superadmin/orgs-ous-and-accounts"
    encrypt         = true
    kms_key_id      = "TFSTATEBACKENDKMSARN"
    dynamodb_table  = "TFSTATEBACKENDDYNAMODBTABLE"
  }
}