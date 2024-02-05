terraform {
  backend "s3" {
    profile         = "superadmin"
    bucket          = "jeremyb-devops-demo-prod-tfstate"
    key             = "org-ou-account-management"
    region          = "us-west-2"
    # dynamodb_table  = ""
    encrypt         = true
    insecure        = false
  }
}