terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.12.0"
    }
  }
}

provider "aws" {
  alias   = "management"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "management_failover"
  profile = var.cli_profile_name
  region  = var.region_failover.full
  default_tags { tags = local.default_tags_map }
}