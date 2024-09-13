# terraform {
#   backend "s3" {
#     profile         = "superadmin"
#     bucket          = "TFSTATEBACKENDS3BUCKETNAME"
#     key             = "org-ou-account-management"
#     region          = "us-west-2"
#     dynamodb_table  = "TFSTATEBACKENDDYNAMODBTABLE"
#     encrypt         = true
#     insecure        = false
#   }
# }