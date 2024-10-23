# terraform {
#   backend "s3" {
#     profile         = "automation"
#     assume_role = {
#       role_arn = "arn:aws:iam::TFSTATEBACKENDORGACCOUNTID:role/automation"
#     }
#     bucket          = "TFSTATEBACKENDS3BUCKETNAME"
#     key             = "project-demo-nonprod"
#     region          = "us-west-2"
#     dynamodb_table  = "TFSTATEBACKENDDYNAMODBTABLE"
#     encrypt         = true
#     insecure        = false
#   }
# }