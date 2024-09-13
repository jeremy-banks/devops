# terraform {
#   backend "s3" {
#     profile         = "automation"
#     assume_role = {
#       role_arn = "arn:aws:iam::TFSTATEBACKENDORGACCOUNTID:role/automation"
#     }
#     bucket          = "TFSTATEBACKENDS3BUCKETNAME"
#     key             = "r53-zones-and-records"
#     region          = "us-west-2"
#     dynamodb_table  = "TFSTATEBACKENDDYNAMO"
#     encrypt         = true
#     insecure        = false
#   }
# }