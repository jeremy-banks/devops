terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.93.0"
    }
  }
}

provider "aws" {
  profile = var.cli_profile_name
  region  = var.region.primary
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "org"
  profile = var.cli_profile_name
  region  = var.region.primary
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "org_failover"
  profile = var.cli_profile_name
  region  = var.region.failover
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "identity_prd"
  profile = var.cli_profile_name
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.identity_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "identity_prd_failover"
  profile = var.cli_profile_name
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.identity_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "log_archive_prd"
  profile = var.cli_profile_name
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.log_archive_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "log_archive_prd_failover"
  profile = var.cli_profile_name
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.log_archive_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "network_prd"
  profile = var.cli_profile_name
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.network_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "network_prd_failover"
  profile = var.cli_profile_name
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.network_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "security_tooling_prd"
  profile = var.cli_profile_name
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.security_tooling_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "security_tooling_prd_failover"
  profile = var.cli_profile_name
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.security_tooling_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "sdlc_prd"
  profile = var.cli_profile_name
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.sdlc_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "sdlc_prd_failover"
  profile = var.cli_profile_name
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.sdlc_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "sdlc_stg"
  profile = var.cli_profile_name
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.sdlc_stg}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "sdlc_stg_failover"
  profile = var.cli_profile_name
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.sdlc_stg}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "sdlc_tst"
  profile = var.cli_profile_name
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.sdlc_tst}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "sdlc_tst_failover"
  profile = var.cli_profile_name
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.sdlc_tst}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "sdlc_dev"
  profile = var.cli_profile_name
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.sdlc_dev}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "sdlc_dev_failover"
  profile = var.cli_profile_name
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.sdlc_dev}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}