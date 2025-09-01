provider "aws" {
  alias   = "this"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${local.this_account_id}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "this_stg"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${local.this_account_id}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

# provider "aws" {
#   alias   = "sdlc_prd"
#   profile = var.cli_profile_name
#   region  = var.region_primary.full
#   assume_role { role_arn = "arn:aws:iam::${local.this_account_id}:role/${var.provider_role_name}" }
#   default_tags { tags = local.default_tags_map }
# }

# provider "aws" {
#   alias   = "this_tst"
#   profile = var.cli_profile_name
#   region  = var.region_primary.full
#   assume_role { role_arn = "arn:aws:iam::${local.this_account_id}:role/${var.provider_role_name}" }
#   default_tags { tags = local.default_tags_map }
# }

# provider "aws" {
#   alias   = "this_dev"
#   profile = var.cli_profile_name
#   region  = var.region_primary.full
#   assume_role { role_arn = "arn:aws:iam::${local.this_account_id}:role/${var.provider_role_name}" }
#   default_tags { tags = local.default_tags_map }
# }

data "aws_caller_identity" "this" { provider = aws.this }

locals {
  this_account_id = var.account_id.network_prd
  this_account_id_stg = var.account_id.network_stg
  # this_account_id_tst = var.account_id.network_tst
  # this_account_id_dev = var.account_id.network_dev

  central_zone_root = "cockydevops.com"
}