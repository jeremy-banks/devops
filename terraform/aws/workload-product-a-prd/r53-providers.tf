locals {
  provider_r53_delegate_dev = join("_", [var.this_slug, "dev"])
  provider_r53_delegate_tst = join("_", [var.this_slug, "tst"])
  provider_r53_delegate_stg = join("_", [var.this_slug, "stg"])
}

provider "aws" {
  alias   = "r53_delegate_dev"
  profile = var.cli_profile_name
  region  = var.region_failover.full
  assume_role { role_arn = "arn:aws:iam::${local.provider_r53_delegate_dev}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "r53_delegate_tst"
  profile = var.cli_profile_name
  region  = var.region_failover.full
  assume_role { role_arn = "arn:aws:iam::${local.provider_r53_delegate_tst}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "r53_delegate_stg"
  profile = var.cli_profile_name
  region  = var.region_failover.full
  assume_role { role_arn = "arn:aws:iam::${local.provider_r53_delegate_stg}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}