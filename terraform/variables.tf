variable "company_name" {
  description = "name or abbreviation of the team"
  type        = string
  default     = "jeremyb"
}

variable "company_email_prefix" {
  description = "name or abbreviation of the team"
  type        = string
  default     = "workjeremy.b"
}

variable "company_email_domain" {
  description = "name or abbreviation of the team"
  type        = string
  default     = "gmail.com"
}

variable "company_domain" {
  description = "name or abbreviation of the team"
  type        = string
  default     = "outerplanes.org"
}

variable "team_name" {
  description = "name or abbreviation of the team"
  type        = string
  default     = "devops"
}

variable "project_name" {
  description = "name or abbreviation of the project"
  type        = string
  default     = "demo"
}

variable "deployment_environment" {
  description = "name of the deployment environment, eg nonprod or prod"
  type        = string
  default     = "nonprod"
}

variable "owner_email" {
  description = "point of escalation for ownership"
  type        = string
  default     = ""
}

variable "cli_profile_name_default" {
  description = "aws profile name to be used"
  type        = string
  default     = "automation"
}

variable "cli_profile_name_substitute" {
  description = "aws profile name to be used"
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

variable "provider_role_name_default" {
  description = ""
  type        = string
  default     = "automation"
}

variable "provider_role_name_substitute" {
  description = ""
  type        = string
  default     = ""
}

variable "iam_access_management_tag_key" {
  description = "iam_access_management_tag key"
  type        = string
  default     = "iam_access_management"
}

variable "ACCOUNT_NUMBER_LIMIT_EXCEEDED" {
  description = "max number of accounts default is 10"
  type        = string
  default     = "25"
}

variable "account_id" {
  type    = map(number)
  default = {
    org               = "782331566564"
    network           = "178506067734"
    shared_services   = "222478945688"
    log_archive       = "346143406940"
    security_tooling  = "419416376566"
    project_demo_nonprod  = "798972386916"
    project_demo_prod     = "945273545397"
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

variable "public_dns" {
  type  = map(string)
  default = {
    aws = "169.254.169.253"
    google = "8.8.8.8"
    azure = "4.2.2.1"
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

locals {
  company_email = "${var.company_email_prefix}@${var.company_email_domain}"
  owner_email = var.owner_email != "" ? var.owner_email : local.company_email

  trimmed_length = 8
  company_name_trimmed = length(var.company_name) > local.trimmed_length ? substr(var.company_name, 0, local.trimmed_length) : var.company_name
  team_name_trimmed = length(var.team_name) > local.trimmed_length ? substr(var.team_name, 0, local.trimmed_length) : var.team_name
  project_name_trimmed = length(var.project_name) > local.trimmed_length ? substr(var.project_name, 0, local.trimmed_length) : var.project_name

/*
remove all vowels except for first character of each word
replace spaces with dashes
truncate each input by local.trimmed_length
lowercase
*/

  resource_name_stub = "${var.company_name}-${var.team_name}-${var.project_name}"
  resource_name_stub_env = "${local.resource_name_stub}-${var.deployment_environment}"
  resource_name_stub_trimmed = "${local.company_name_trimmed}-${local.team_name_trimmed}-${local.project_name_trimmed}"
  resource_name_stub_env_trimmed = "${local.resource_name_stub_trimmed}-${var.deployment_environment}"

  cli_profile_name = var.cli_profile_name_substitute != "" ? var.cli_profile_name_substitute : var.cli_profile_name_default
  provider_role_name = var.provider_role_name_substitute != "" ? var.provider_role_name_substitute : var.provider_role_name_default

  vpc_domain_name_servers = [var.public_dns.aws, var.public_dns.google, var.public_dns.azure]
  vpc_ntp_servers = [var.ntp_server]

  application_load_balancer_allow_list = "foo"

  iam_access_management_tag_key = var.iam_access_management_tag_key
  iam_access_management_tag_value = "${local.resource_name_stub}"
  iam_access_management_tag_map = { "${local.iam_access_management_tag_key}" = "${local.iam_access_management_tag_value}" }

  default_tags_map = {
    "company"     = var.company_name #Microsoft
    "team"        = var.team_name #Blue
    "project"     = var.project_name #Windows
    "environment" = var.deployment_environment #prod|nonprod
    "owner_email" = local.owner_email
    "tool"        = "terraform"
  }

  default_tags = merge(local.default_tags_map, local.iam_access_management_tag_map)
}