# terraform {
#   backend "s3" {
#     profile         = "superadmin"
#     bucket          = "TFSTATEBACKENDS3BUCKETNAME"
#     key             = "superadmin/tfstate-backend"
#     region          = "TFSTATEBACKENDREGION"
#     dynamodb_table  = "TFSTATEBACKENDDYNAMODBTABLE"
#     encrypt         = true
#     insecure        = false
#   }
# }