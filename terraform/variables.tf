variable "org_owner_email_prefix" {
  description = "the 'billg' in 'billg@microsoft'"
  type        = string
  default     = "workjeremyb+assess4"
}

variable "org_owner_email_domain" {
  description = "the 'microsoft.com' in 'billg@microsoft.com'"
  type        = string
  default     = "gmail.com"
}

variable "company_domain" {
  description = "company domain"
  type        = string
  default     = "outerplanes.org"
}

variable "company_name" {
  description = "name of the company"
  type        = string
  default     = "supercoolcompany"
}

variable "company_name_abbr" {
  description = "abbreviation of the company name"
  type        = string
  default     = "scc"
}

variable "team_name" {
  description = "name of the team"
  type        = string
  default     = "blue"
}

variable "team_name_abbr" {
  description = "abbreviation of the team name"
  type        = string
  default     = "blue"
}

variable "project_name" {
  description = "name of the project"
  type        = string
  default     = "windows12"
}

variable "project_name_abbr" {
  description = "abbreviation of the project name"
  type        = string
  default     = "w12"
}

variable "deployment_environment" {
  description = "name of the deployment environment, eg nonprod or prod"
  type        = string
  default     = "nonprod"
}

variable "resource_owner_email" {
  description = "point of escalation for ownership"
  type        = string
  default     = ""
}

variable "cli_profile_name_aws" {
  description = "aws profile name to be used"
  type        = string
  default     = "automation"
}

variable "cli_profile_name_aws_substitute" {
  description = "substitute aws profile name to use"
  type        = string
  default     = ""
}

variable "region" {
  description = "regions for the infrastructure"
  type        = map(string)
  default     = {
    primary   = "us-west-2"
    failover  = "us-east-1"
    primary_short   = "usw2"
    failover_short  = "use1"
  }
}

variable "availability_zones" {
  description = "specific AZs to use to lower latency"
  type        = map(list(string))
  default     = {
    primary = [
      "usw2-az1",
      "usw2-az3",
    ]
    failover = [
      "use1-az2",
      "use1-az4",
    ]
  }
}

variable "assumable_roles_name" {
  description = ""
  type        = map(string)
  default     = {
    admin       = "admin"
    poweruser   = "poweruser"
    readonly    = "readonly"
  }
}

variable "assumable_role_name" {
  description = ""
  type        = map(string)
  default     = {
    superadmin  = "superadmin"
    automation  = "automation"
  }
}

variable "provider_role_name" {
  description = "role name to use for terraform provider"
  type        = string
  default     = "automation"
}

variable "provider_role_name_substitute" {
  description = "substitute role name to use for terraform provider"
  type        = string
  default     = ""
}

variable "iam_access_management_tag_key" {
  description = "iam_access_management_tag key"
  type        = string
  default     = "iam_access_management"
}

variable "account_id" {
  type    = map(number)
  default = {
    log_archive = "314146296298"
    network = "739275473054"
    org = "686255956644"
    project_demo_nonprod = "148761641725"
    project_demo_prod = "418272785605"
    security_tooling = "741448947403"
    shared_services = "183631311282"
  }
}

variable "tgw_asn" {
  type  = map(number)
  default = {
    primary = 65434
    failover = 65433
  }
}

variable "vpc_prefixes" {
  type    = map(map(string))
  default = {
    shared_vpc = {
      primary = "10.41"
      failover = "10.42"
    }
    client_vpn = {
      primary = "10.51"
      failover = "10.52"
    }
    project_demo_nonprod = {
      primary = "10.43"
      failover = "10.44"
    }
    project_demo_prod = {
      primary = "10.45"
      failover = "10.46"
    }
  }
}

variable "vpc_suffixes" {
  type    = map(string)
  default = {
    subnet_public_a = "128.0/20"
    subnet_public_b = "144.0/20"
    subnet_private_a = "0.0/18"
    subnet_private_b = "64.0/18"
    # remaining
    # 160.0/19
    # 192.0/18
  }
}

variable "vpc_suffixes_2az" {
  description = "two public subnets with 4k addresses and two private subnets with 16k addresses"
  type    = map(string)
  default = {
    subnet_public_a = "128.0/20"
    subnet_public_b = "144.0/20"
    subnet_private_a = "0.0/18"
    subnet_private_b = "64.0/18"
    # remaining
    # 160.0/19
    # 192.0/18
  }
}

variable "vpc_suffixes_3az" {
  description = "three public subnets with 4k addresses and three private subnets with 16k addresses"
  type    = map(string)
  default = {
    subnet_public_a = "192.0/20"
    subnet_public_b = "208.0/20"
    subnet_public_c = "224.0/20	"
    subnet_private_a = "0.0/18"
    subnet_private_b = "64.0/18"
    subnet_private_c = "128.0/18"
    # remaining
    # 240.0/2
  }
}

variable "ntp_server" {
  type  = string
  default = "169.254.169.123"
}

variable "ipv_to_allow_substitute"{
  type  = string
  default = ""
}

variable "ad_directory_admin_password" {
  type  = string
  default = "tempSuperSecretPassword123"
}

variable "ad_directory_id_connector_network" {
  type  = string
  default = ""
}

variable "ad_directory_id_connector_network_failover" {
  type  = string
  default = ""
}

locals {
  cli_profile_name_aws = var.cli_profile_name_aws_substitute != "" ? var.cli_profile_name_aws_substitute : var.cli_profile_name_aws
  provider_role_name = var.provider_role_name_substitute != "" ? var.provider_role_name_substitute : var.provider_role_name

  org_owner_email = "${var.org_owner_email_prefix}@${var.org_owner_email_domain}"
  resource_owner_email = var.resource_owner_email != "" ? var.resource_owner_email : local.org_owner_email

  resource_name_prefix = "${var.company_name}-${var.team_name}-${var.project_name}"
  resource_name_prefix_env = "${local.resource_name_prefix}-${var.deployment_environment}"
  resource_name_prefix_env_region_primary = "${local.resource_name_prefix_env}-${var.region.primary_short}"
  resource_name_prefix_env_region_failover = "${local.resource_name_prefix_env}-${var.region.failover_short}"

  resource_name_prefix_abbr = "${var.company_name_abbr}-${var.team_name_abbr}-${var.project_name_abbr}"
  resource_name_prefix_env_abbr = "${local.resource_name_prefix_abbr}-${var.deployment_environment}"
  resource_name_prefix_env_region_primary_abbr = "${local.resource_name_prefix_env_abbr}-${var.region.primary_short}"
  resource_name_prefix_env_region_failover_abbr = "${local.resource_name_prefix_env_abbr}-${var.region.failover_short}"

  vpc_ntp_servers = [var.ntp_server]

  application_load_balancer_allow_list = "foo"

  iam_access_management_tag_key = var.iam_access_management_tag_key
  iam_access_management_tag_value = "${local.resource_name_prefix}"
  iam_access_management_tag_map = { "${local.iam_access_management_tag_key}" = "${local.iam_access_management_tag_value}" }

  default_tags_map = {
    "company"         = var.company_name #Microsoft
    "team"            = var.team_name #Blue
    "project"         = var.project_name #Windows
    "environment"     = var.deployment_environment #prod|nonprod
    "resource_owner"  = local.resource_owner_email
    "tool"            = "terraform"
  }

  default_tags = merge(local.default_tags_map, local.iam_access_management_tag_map)
}