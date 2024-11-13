terraform {
  backend "s3" {
    profile         = "automation"
    assume_role     = { role_arn = "arn:aws:iam::TFSTATEBACKENDORGACCOUNTID:role/automation" }
    insecure        = false
    region          = "TFSTATEBACKENDREGION"
    bucket          = "TFSTATEBACKENDS3BUCKETNAME"
    key             = "automation/client-vpn"
    encrypt         = true
    kms_key_id      = "TFSTATEBACKENDKMSARN"
    dynamodb_table  = "TFSTATEBACKENDDYNAMODBTABLE"
  }
}