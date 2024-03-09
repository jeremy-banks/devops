# terraform {
#   backend "s3" {
#     profile         = "automation"
#     assume_role = {
#       role_arn = "arn:aws:iam::123456789012:role/automation"
#     }
#     bucket          = ""
#     key             = "r53-zones-and-records"
#     region          = "us-west-2"
#     # dynamodb_table  = ""
#     encrypt         = true
#     insecure        = false
#   }
# }