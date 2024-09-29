terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.35.0"
    }
  }
}

provider "aws" {
  profile = local.cli_profile_name_aws
  region  = var.region.primary
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "org"
  profile = local.cli_profile_name_aws
  region  = var.region.primary
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "org_failover"
  profile = local.cli_profile_name_aws
  region  = var.region.failover
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "network"
  profile = local.cli_profile_name_aws
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.network}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "network_failover"
  profile = local.cli_profile_name_aws
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.network}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "shared_services"
  profile = local.cli_profile_name_aws
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.shared_services}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "shared_services_failover"
  profile = local.cli_profile_name_aws
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.shared_services}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "log_archive"
  profile = local.cli_profile_name_aws
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.log_archive}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "log_archive_failover"
  profile = local.cli_profile_name_aws
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.log_archive}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "security_tooling"
  profile = local.cli_profile_name_aws
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.security_tooling}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "security_tooling_failover"
  profile = local.cli_profile_name_aws
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.security_tooling}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "project_demo_nonprod"
  profile = local.cli_profile_name_aws
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.project_demo_nonprod}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "project_demo_nonprod_failover"
  profile = local.cli_profile_name_aws
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.project_demo_nonprod}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "project_demo_prod"
  profile = local.cli_profile_name_aws
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.project_demo_prod}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "project_demo_prod_failover"
  profile = local.cli_profile_name_aws
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.project_demo_prod}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}