terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.73.0"
    }
  }
}

provider "aws" {
  profile = var.cli_profile_name_aws
  region  = var.region.primary
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias = "org"
  profile = var.cli_profile_name_aws
  region  = var.region.primary
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias = "org_failover"
  profile = var.cli_profile_name_aws
  region  = var.region.failover
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias = "identity"
  profile = var.cli_profile_name_aws
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.identity}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias = "identity_failover"
  profile = var.cli_profile_name_aws
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.identity}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias = "log_archive"
  profile = var.cli_profile_name_aws
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.log_archive}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias = "log_archive_failover"
  profile = var.cli_profile_name_aws
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.log_archive}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias = "network"
  profile = var.cli_profile_name_aws
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.network}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias = "network_failover"
  profile = var.cli_profile_name_aws
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.network}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias = "security_tooling"
  profile = var.cli_profile_name_aws
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.security_tooling}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias = "security_tooling_failover"
  profile = var.cli_profile_name_aws
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.security_tooling}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias = "sdlc_prd"
  profile = var.cli_profile_name_aws
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.sdlc_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias = "sdlc_prd_failover"
  profile = var.cli_profile_name_aws
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.sdlc_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias = "sdlc_stg"
  profile = var.cli_profile_name_aws
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.sdlc_stg}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias = "sdlc_stg_failover"
  profile = var.cli_profile_name_aws
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.sdlc_stg}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias = "sdlc_tst"
  profile = var.cli_profile_name_aws
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.sdlc_tst}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias = "sdlc_tst_failover"
  profile = var.cli_profile_name_aws
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.sdlc_tst}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias = "sdlc_dev"
  profile = var.cli_profile_name_aws
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.sdlc_dev}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias = "sdlc_dev_failover"
  profile = var.cli_profile_name_aws
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.sdlc_dev}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}