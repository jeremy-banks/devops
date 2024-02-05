terraform {
  backend "s3" {
    profile         = "automation"
    assume_role = {
      role_arn = "arn:aws:iam::992382439092:role/automation"
    }
    bucket          = "jeremyb-devops-demo-prod-tfstate"
    key             = "r53-zones-and-records"
    region          = "us-west-2"
    # dynamodb_table  = ""
    encrypt         = true
    insecure        = false
  }
}