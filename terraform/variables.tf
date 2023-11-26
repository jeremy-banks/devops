variable "company_name" {
  description = "name or abbreviation of the team"
  type        = string
  default     = "jeremy"
}

variable "company_email_prefix" {
  description = "name or abbreviation of the team"
  type        = string
  default     = "workjeremyb"
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

variable "region_primary" {
  description = "region to be used for all resources"
  type        = string
  default     = "us-east-1"
}

variable "region_secondary" {
  description = "region to be used for backup/standby/dr"
  type        = string
  default     = "us-west-2"
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

variable "account_numbers" {
  description = "max number of accounts default is 10"
  type        = map(number)
  default     = {
    org               = "782331566564"
    network           = "373226670881"
    shared-services   = "898444532447"
    log-archive       = "145810376262"
    security-tooling  = "427272690860"
    project1-nonprod  = "841957403114"
    project-prod      = "170370546750"
  }
}

locals {
  default_tags_map = {
    "company" = var.company_name
    "environment" = var.deployment_environment
    "project" = var.project_name
    "team" = var.team_name
    "tool" = "terraform"
  }

  company_email = "${var.company_email_prefix}@${var.company_email_domain}"

  trimmed_length = 8
  company_name_trimmed = length(var.company_name) > local.trimmed_length ? substr(var.company_name, 0, local.trimmed_length) : var.company_name
  team_name_trimmed = length(var.team_name) > local.trimmed_length ? substr(var.team_name, 0, local.trimmed_length) : var.team_name
  project_name_trimmed = length(var.project_name) > local.trimmed_length ? substr(var.project_name, 0, local.trimmed_length) : var.project_name

  resource_name_stub = "${local.company_name_trimmed}-${local.team_name_trimmed}-${local.project_name_trimmed}"
  resource_name_env_stub = "${local.resource_name_stub}-${var.deployment_environment}"

  iam_access_management_tag_key = var.iam_access_management_tag_key
  iam_access_management_tag_value = "${local.resource_name_stub}"
  iam_access_management_tag_map = { "${local.iam_access_management_tag_key}" = "${local.iam_access_management_tag_value}" }
}