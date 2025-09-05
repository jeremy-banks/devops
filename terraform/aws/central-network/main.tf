provider "aws" {
  alias   = "this"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${local.this_account_id}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "this_failover"
  profile = var.cli_profile_name
  region  = var.region_failover.full
  assume_role { role_arn = "arn:aws:iam::${local.this_account_id}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

data "aws_caller_identity" "this" { provider = aws.this }

data "aws_organizations_organization" "this" { provider = aws.this }

# data "aws_organizations_organizational_units" "top_level" {
#   provider = aws.management

#   parent_id = data.aws_organizations_organization.this.roots[0].id
# }

# data "aws_organizations_organizational_unit" "infrastructure" {
#   provider = aws.management

#   parent_id = data.aws_organizations_organization.this.roots[0].id
#   name      = "infrastructure"
# }

# data "aws_organizations_organizational_unit" "security" {
#   provider = aws.management

#   parent_id = data.aws_organizations_organization.this.roots[0].id
#   name      = "security"
# }

# data "aws_organizations_organizational_unit" "workloads" {
#   provider = aws.management

#   parent_id = data.aws_organizations_organization.this.roots[0].id
#   name      = "workloads"
# }

locals {
  this_account_id = var.account_id.network_prd
}