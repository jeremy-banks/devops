terraform {
  backend "s3" {
    profile         = "superadmin"
    insecure        = false
    region          = "TFSTATEBACKENDREGION"
    bucket          = "TFSTATEBACKENDS3BUCKETNAME"
    key             = "superadmin/iam-groups-and-roles"
    encrypt         = true
    kms_key_id      = "TFSTATEBACKENDKMSKEYARN"
    dynamodb_table  = "TFSTATEBACKENDDYNAMODBTABLE"
  }
}