# provider "aws" {
#   alias   = "this"
#   profile = var.cli_profile_name
#   region  = var.region_primary.full
#   default_tags { tags = local.default_tags_map }
# }

# provider "aws" {
#   alias   = "this_failover"
#   profile = var.cli_profile_name
#   region  = var.region_failover.full
#   default_tags { tags = local.default_tags_map }
# }

data "aws_caller_identity" "this" { provider = aws.management }

# locals {
#   this_account_id = var.account_id.identity_prd
# }