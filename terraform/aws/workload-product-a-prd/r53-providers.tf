locals {
  this_prd = join("_", ["workload", replace(var.this_slug, "-", "_"), "prd"])
  this_stg = join("_", ["workload", replace(var.this_slug, "-", "_"), "stg"])
  this_tst = join("_", ["workload", replace(var.this_slug, "-", "_"), "tst"])
  this_dev = join("_", ["workload", replace(var.this_slug, "-", "_"), "dev"])
}

provider "aws" {
  alias   = "this_prd"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${lookup(var.account_id, local.this_prd)}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "this_stg"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${lookup(var.account_id, local.this_stg)}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "this_tst"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${lookup(var.account_id, local.this_tst)}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "this_dev"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${lookup(var.account_id, local.this_dev)}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}