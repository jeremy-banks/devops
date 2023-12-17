terraform {
  # backend "s3" {
  #   profile         = ""
  #   bucket          = ""
  #   key             = ""
  #   region          = ""
  #   dynamodb_table  = ""
  #   encrypt         = true
  #   insecure        = false
  # }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.22.0"
    }

    shell = {
      source = "scottwinkler/shell"
      version = "1.7.10"
    }

    sops = {
      source = "carlpett/sops"
      version = "1.0.0"
    }
  }
}

# provider "sops" {}

# data "sops_file" "secrets" {
#   source_file = "secrets.yaml"
# }

provider "aws" {
  profile = local.cli_profile_name
  region  = var.region.primary
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "org"
  profile = local.cli_profile_name
  region  = var.region.primary
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "org_failover"
  profile = local.cli_profile_name
  region  = var.region.failover
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "network"
  profile = local.cli_profile_name
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.network}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "network_failover"
  profile = local.cli_profile_name
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.network}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "shared_services"
  profile = local.cli_profile_name
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.shared_services}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "shared_services_failover"
  profile = local.cli_profile_name
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.shared_services}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "log_archive"
  profile = local.cli_profile_name
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.log_archive}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "log_archive_failover"
  profile = local.cli_profile_name
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.log_archive}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "security_tooling"
  profile = local.cli_profile_name
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.security_tooling}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "security_tooling_failover"
  profile = local.cli_profile_name
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.security_tooling}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "project_nonprod"
  profile = local.cli_profile_name
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.project_nonprod}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "project_nonprod_failover"
  profile = local.cli_profile_name
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.project_nonprod}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "project_prod"
  profile = local.cli_profile_name
  region  = var.region.primary
  assume_role { role_arn = "arn:aws:iam::${var.account_id.project_prod}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}

provider "aws" {
  alias = "project_prod_failover"
  profile = local.cli_profile_name
  region  = var.region.failover
  assume_role { role_arn = "arn:aws:iam::${var.account_id.project_prod}:role/${local.provider_role_name}" }
  default_tags { tags = local.default_tags }
}