terraform {
  backend "s3" {
    profile         = "superadmin"
    bucket          = ""
    key             = "iam-groups-and-roles"
    region          = "us-west-2"
    # dynamodb_table  = ""
    encrypt         = true
    insecure        = false
  }
}