terraform {
  backend "s3" {
    profile         = "automation"
    bucket          = "jeremy-banks-devops-demo-tfstate"
    key             = "aws/network-r53"
    region          = "us-west-2"
    dynamodb_table  = "jeremy-banks-devops-demo-tflock"
    encrypt         = true
    insecure        = false
  }
  
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
  profile = "automation"
  region  = var.region_primary
  assume_role { role_arn = "arn:aws:iam::${var.account_numbers.network}:role/admin" }

  default_tags {
    tags = merge(
      local.default_tags_map,
      local.iam_access_management_tag_map
    )
  }
}

provider "aws" {
  alias = "log-archive"
  profile = "automation"
  region  = var.region_primary
  assume_role { role_arn = "arn:aws:iam::${var.account_numbers.log-archive}:role/admin" }

  default_tags {
    tags = merge(
      local.default_tags_map,
      local.iam_access_management_tag_map
    )
  }
}

provider "aws" {
  alias = "log-archive-dr"
  profile = "automation"
  region  = var.region_secondary
  assume_role { role_arn = "arn:aws:iam::${var.account_numbers.log-archive}:role/admin" }

  default_tags {
    tags = merge(
      local.default_tags_map,
      local.iam_access_management_tag_map
    )
  }
}