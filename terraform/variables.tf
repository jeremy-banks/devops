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
  default     = "jbdevopsdemo.com"
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
  description = "max number of accounts default is 10"
  type        = map(number)
  default     = {
    org               = "782331566564"
    network           = "178506067734"
    shared_services   = "222478945688"
    log_archive       = "346143406940"
    security_tooling  = "419416376566"
    project_demo_nonprod  = "798972386916"
    project_demo_prod     = "945273545397"
  }
}

locals {
  default_tags_map = {
    "company"     = var.company_name
    "environment" = var.deployment_environment
    "project"     = var.project_name
    "team"        = var.team_name
    "tool"        = "terraform"
  }

  company_email = "${var.company_email_prefix}@${var.company_email_domain}"

  trimmed_length = 8
  company_name_trimmed = length(var.company_name) > local.trimmed_length ? substr(var.company_name, 0, local.trimmed_length) : var.company_name
  team_name_trimmed = length(var.team_name) > local.trimmed_length ? substr(var.team_name, 0, local.trimmed_length) : var.team_name
  project_name_trimmed = length(var.project_name) > local.trimmed_length ? substr(var.project_name, 0, local.trimmed_length) : var.project_name

  resource_name_stub = "${var.company_name}-${var.team_name}-${var.project_name}"
  resource_name_env_stub = "${local.resource_name_stub}-${var.deployment_environment}"
  resource_name_stub_trimmed = "${local.company_name_trimmed}-${local.team_name_trimmed}-${local.project_name_trimmed}"
  resource_name_env_stub_trimmed = "${local.company_name_trimmed}-${local.team_name_trimmed}-${local.project_name_trimmed}-${var.deployment_environment}"

  iam_access_management_tag_key = var.iam_access_management_tag_key
  iam_access_management_tag_value = "${local.resource_name_stub}"
  iam_access_management_tag_map = { "${local.iam_access_management_tag_key}" = "${local.iam_access_management_tag_value}" }

  default_tags = merge(local.default_tags_map, local.iam_access_management_tag_map)

  cli_profile_name = var.cli_profile_name_substitute != "" ? var.cli_profile_name_substitute : var.cli_profile_name_default
  provider_role_name = var.provider_role_name_substitute != "" ? var.provider_role_name_substitute : var.provider_role_name_default
}