terraform {
  backend "s3" {
    profile         = "automation"
    assume_role     = { role_arn = "arn:aws:iam::TFSTATEBACKENDORGACCOUNTID:role/automation" }
    insecure        = false
    region          = "TFSTATEBACKENDREGION"
    bucket          = "TFSTATEBACKENDS3BUCKETNAME"
    key             = "automation/tgw-and-network-vpc"
    encrypt         = true
    kms_key_id      = "TFSTATEBACKENDKMSKEYARN"
    dynamodb_table  = "TFSTATEBACKENDDYNAMODBTABLE"
  }
}