variable "org_owner_email_prefix" {
  description = "the 'billg' in 'billg@microsoft'"
  type        = string
  default     = "billg"
}

variable "org_owner_email_domain" {
  description = "the 'microsoft.com' in 'billg@microsoft.com'"
  type        = string
  default     = "microsoft.com"
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
  description = "name of the deployment environment, eg dev, tst, stg, prd"
  type        = string
  default     = "dev"
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

variable "account_id" {
  type    = map(string)
  default = {
    identity = ""
    log_archive = ""
    network = ""
    org = ""
    sdlc_prd = ""
    security_tooling = ""
  }
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

variable "tgw_asn" {
  type  = map(number)
  default = {
    primary = 65434
    failover = 65433
  }
}

variable "vpc_cidr_primary_substitute" {
  type = string
  default = ""
}

variable "vpc_cidr_failover_substitute" {
  type = string
  default = ""
}

variable "vpc_cidr_network_primary" {
  type = string
  default = "10.41.0.0/16"
}

variable "vpc_cidr_network_failover" {
  type = string
  default = "10.42.0.0/16"
}

variable "vpc_cidr_clientvpn_primary" {
  type = string
  default = "10.43.0.0/16"
}

variable "vpc_cidr_clientvpn_failover" {
  type = string
  default = "10.44.0.0/16"
}

variable "vpc_cidr_sdlc_prod_primary" {
  type = string
  default = "10.51.0.0/16"
}

variable "vpc_cidr_sdlc_prod_failover" {
  type = string
  default = "10.52.0.0/16"
}

variable "vpc_cidr_sdlc_nonprod_primary" {
  type = string
  default = "10.53.0.0/16"
}

variable "vpc_cidr_sdlc_nonprod_failover" {
  type = string
  default = "10.54.0.0/16"
}

variable "availability_zones_double" {
  type = map(list(string))
  default = {
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

variable "availability_zones_triple" {
  type = map(list(string))
  default = {
    primary = [
      "usw2-az1",
      "usw2-az3",
      "usw2-az4",
    ]
    failover = [
      "use1-az2",
      "use1-az4",
      "use1-az5",
    ]
  }
}

variable "ntp_server" {
  type  = string
  default = "169.254.169.123"
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

  #company - team - project - env
  resource_name_stub = "${var.company_name_abbr}-${var.team_name_abbr}-${var.project_name_abbr}"
  
  #wo region
  #wo environment
  #w region primary
  #w region fail

  #abbr
  
  #delimiter

  # resource_name_prefix = "${var.company_name}-${var.team_name}-${var.project_name}"
  # resource_name_prefix_env = "${local.resource_name_prefix}-${var.deployment_environment}"
  # resource_name_prefix_env_region_primary = "${local.resource_name_prefix_env}-${var.region.primary_short}"
  # resource_name_prefix_env_region_failover = "${local.resource_name_prefix_env}-${var.region.failover_short}"

  # resource_name_prefix_abbr = "${var.company_name_abbr}-${var.team_name_abbr}-${var.project_name_abbr}"
  # resource_name_prefix_env_abbr = "${local.resource_name_prefix_abbr}-${var.deployment_environment}"
  # resource_name_prefix_env_region_primary_abbr = "${local.resource_name_prefix_env_abbr}-${var.region.primary_short}"
  # resource_name_prefix_env_region_failover_abbr = "${local.resource_name_prefix_env_abbr}-${var.region.failover_short}"

  vpc_cidr_primary = var.vpc_cidr_primary_substitute != "" ? var.vpc_cidr_primary_substitute : var.vpc_cidr_sdlc_nonprod_primary
  vpc_azs_primary = var.deployment_environment == "prd" || var.deployment_environment == "stg" ? var.availability_zones_triple.primary : var.availability_zones_double.primary
  vpc_subnets_private_primary = [for k in range(length(local.vpc_azs_primary)) : cidrsubnet(local.vpc_cidr_primary, 2, k)]
  vpc_subnets_public_primary = [for k in range(length(local.vpc_azs_primary)) : cidrsubnet(local.vpc_cidr_primary, 4, k + (4 * length(local.vpc_azs_primary)))]
  vpc_cidr_primary_split = split(".", cidrsubnet(local.vpc_cidr_primary, 0, 0))
  vpc_dns_primary = join(".", [local.vpc_cidr_primary_split[0], local.vpc_cidr_primary_split[1], local.vpc_cidr_primary_split[2], "2"])

  vpc_cidr_failover = var.vpc_cidr_failover_substitute != "" ? var.vpc_cidr_failover_substitute : var.vpc_cidr_sdlc_nonprod_failover
  vpc_azs_failover = var.deployment_environment == "prd" || var.deployment_environment == "stg" ? var.availability_zones_triple.failover : var.availability_zones_double.failover
  vpc_subnets_private_failover = [for k in range(length(local.vpc_azs_failover)) : cidrsubnet(local.vpc_cidr_failover, 2, k)]
  vpc_subnets_public_failover = [for k in range(length(local.vpc_azs_failover)) : cidrsubnet(local.vpc_cidr_failover, 4, k + (4 * length(local.vpc_azs_failover)))]
  vpc_cidr_failover_split = split(".", cidrsubnet(local.vpc_cidr_failover, 0, 0))
  vpc_dns_failover = join(".", [local.vpc_cidr_failover_split[0], local.vpc_cidr_failover_split[1], local.vpc_cidr_failover_split[2], "2"])

  vpc_ntp_servers = [var.ntp_server]

  application_load_balancer_allow_list = "foo"

  iam_access_management_tag_key = var.iam_access_management_tag_key
  iam_access_management_tag_value = "${local.resource_name_stub}"
  iam_access_management_tag_map = { "${local.iam_access_management_tag_key}" = "${local.iam_access_management_tag_value}" }

  default_tags_map = {
    "company"         = var.company_name #Microsoft
    "team"            = var.team_name #Blue
    "project"         = var.project_name #Windows
    "environment"     = var.deployment_environment #dev|tst|stg|prd
    "resource_owner"  = local.resource_owner_email
    "tool"            = "terraform"
  }

  default_tags = merge(local.default_tags_map, local.iam_access_management_tag_map)
}