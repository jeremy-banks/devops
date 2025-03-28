# terraform {
#   backend "s3" {
#     profile         = "superadmin"
#     insecure        = false
#     region          = "TFSTATEBACKENDREGION"
#     bucket          = "TFSTATEBACKENDS3BUCKETNAME"
#     key             = "superadmin/management-account"
#     encrypt         = true
#     kms_key_id      = "TFSTATEBACKENDKMSARN"
#     dynamodb_table  = "TFSTATEBACKENDDYNAMODBTABLE"
#   }
# }