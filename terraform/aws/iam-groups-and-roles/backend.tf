# terraform {
#   backend "s3" {
#     profile         = "superadmin"
#     bucket          = "TFSTATEBACKENDS3BUCKETNAME"
#     key             = "iam-groups-and-roles"
#     region          = "us-west-2"
#     dynamodb_table  = "TFSTATEBACKENDDYNAMODBTABLE"
#     encrypt         = true
#     insecure        = false
#   }
# }