terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.96.0"
    }
  }
}

provider "aws" {
  profile = var.cli_profile_name
  region  = var.region.primary
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "management"
  profile = var.cli_profile_name
  region  = var.region.primary
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "management_failover"
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
  alias   = "workload_spoke_prd"
  profile = var.cli_profile_name
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.workload_spoke_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "workload_spoke_prd_failover"
  profile = var.cli_profile_name
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.workload_spoke_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}
