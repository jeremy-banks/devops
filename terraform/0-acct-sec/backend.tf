provider "aws" {
  profile = terraform.workspace
}

terraform {
  backend "s3" {
    bucket         = "jeremy-banks-devops-demo-tfstate"
    key            = "0-acct-sec"
    region         = "us-west-2"
    dynamodb_table = "jeremy-banks-devops-demo-tflock"
    encrypt        = true
  }
}