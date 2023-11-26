terraform {
  backend "s3" {
    profile         = "automation"
    bucket          = "jeremy-banks-devops-demo-tfstate"
    key             = "aws/org-iam-groups-and-roles"
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

  default_tags {
    tags = merge(
      local.default_tags_map,
      local.iam_access_management_tag_map
    )
  }
}

provider "aws" {
  alias = "network"
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
  alias = "shared-services"
  profile = "automation"
  region  = var.region_primary
  assume_role { role_arn = "arn:aws:iam::${var.account_numbers.shared-services}:role/admin" }

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
  alias = "security-tooling"
  profile = "automation"
  region  = var.region_primary
  assume_role { role_arn = "arn:aws:iam::${var.account_numbers.security-tooling}:role/admin" }

  default_tags {
    tags = merge(
      local.default_tags_map,
      local.iam_access_management_tag_map
    )
  }
}

provider "aws" {
  alias = "project1-nonprod"
  profile = "automation"
  region  = var.region_primary
  assume_role { role_arn = "arn:aws:iam::${var.account_numbers.project1-nonprod}:role/admin" }

  default_tags {
    tags = merge(
      local.default_tags_map,
      local.iam_access_management_tag_map
    )
  }
}

provider "aws" {
  alias = "project1-prod"
  profile = "automation"
  region  = var.region_primary
  assume_role { role_arn = "arn:aws:iam::${var.account_numbers.project1-prod}:role/admin" }

  default_tags {
    tags = merge(
      local.default_tags_map,
      local.iam_access_management_tag_map
    )
  }
}