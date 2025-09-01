provider "aws" {
  alias   = "shared_services_prd"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.shared_services_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "shared_services_stg"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.shared_services_stg}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}