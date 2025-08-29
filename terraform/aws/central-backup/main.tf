provider "aws" {
  alias   = "this"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.identity_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "this_failover"
  profile = var.cli_profile_name
  region  = var.region_failover.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.identity_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

data "aws_caller_identity" "root" {}

data "aws_caller_identity" "this" { provider = aws.shared_services_prd }

data "aws_organizations_organization" "this" {}