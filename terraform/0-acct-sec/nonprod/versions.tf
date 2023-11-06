terraform {
  backend "s3" {
    profile        = "nonprod"
    bucket         = "jeremy-banks-devops-demo-tfstate"
    key            = "0-acct-sec/nonprod"
    region         = "us-west-2"
    dynamodb_table = "jeremy-banks-devops-demo-tflock"
    encrypt        = true
    insecure       = false
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.22.0"
    }

    shell = {
      source = "scottwinkler/shell"
      version = "1.7.10"
    }
  }
}

provider "aws" {
  profile = var.environment
  region  = var.region

  default_tags {
    tags = {
      "${var.provisioned_by_iac_tag}" = "true"
      "environment" = var.environment
      "name" = var.name
    }
  }
}
