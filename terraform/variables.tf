variable "account_id" {
  type = map(string)
  default = {
    identity_prd           = "000000000000"
    identity_stg           = "000000000000"
    log_archive_prd        = "000000000000"
    log_archive_stg        = "000000000000"
    network_prd            = "000000000000"
    network_stg            = "000000000000"
    sdlc_dev               = "000000000000"
    sdlc_prd               = "000000000000"
    sdlc_stg               = "000000000000"
    sdlc_tst               = "000000000000"
    security_tooling_prd   = "000000000000"
    security_tooling_stg   = "000000000000"
    shared_services_prd    = "000000000000"
    shared_services_stg    = "000000000000"
    workload_product_a_dev = "000000000000"
    workload_product_a_prd = "000000000000"
    workload_product_a_stg = "000000000000"
    workload_product_a_tst = "000000000000"
  }
}

variable "account_name" {
  type = map(string)
  default = {
    identity           = "identity"
    log_archive        = "log-archive"
    network            = "network"
    sandbox            = "sandbox"
    sdlc               = "sdlc"
    security_tooling   = "security-tooling"
    shared_services    = "shared-services"
    workload_product_a = "product-a"
  }
}

variable "r53_delegate" {
  type = map(string)
  default = {
    identity           = "id"
    log_archive        = "log"
    sandbox            = "sbx"
    sdlc               = "sdlc"
    security_tooling   = "sec"
    shared_services    = "svc"
    workload_product_a = "pa"
  }
}

variable "vpc_cidr" {
  type = map(string)
  default = {
    transit_gateway = "10.0.0.0/8"

    central_inspection_prd_primary  = "10.0.0.0/16"
    central_inspection_prd_failover = "10.1.0.0/16"
    central_inspection_stg_primary  = "10.2.0.0/16"
    central_inspection_stg_failover = "10.3.0.0/16"

    central_egress_prd_primary  = "10.4.0.0/16"
    central_egress_prd_failover = "10.5.0.0/16"
    central_egress_stg_primary  = "10.6.0.0/16"
    central_egress_stg_failover = "10.7.0.0/16"

    client_vpn_prd_primary  = "10.8.0.0/16"
    client_vpn_prd_failover = "10.9.0.0/16"
    client_vpn_stg_primary  = "10.10.0.0/16"
    client_vpn_stg_failover = "10.11.0.0/16"

    shared_services_prd_primary  = "10.12.0.0/16"
    shared_services_prd_failover = "10.13.0.0/16"
    shared_services_stg_primary  = "10.14.0.0/16"
    shared_services_stg_failover = "10.15.0.0/16"

    sdlc_prd_primary  = "10.16.0.0/16"
    sdlc_prd_failover = "10.17.0.0/16"
    sdlc_stg_primary  = "10.18.0.0/16"
    sdlc_stg_failover = "10.19.0.0/16"
    sdlc_tst_primary  = "10.20.0.0/16"
    sdlc_tst_failover = "10.21.0.0/16"
    sdlc_dev_primary  = "10.22.0.0/16"
    sdlc_dev_failover = "10.23.0.0/16"

    workload_product_a_prd_primary  = "10.24.0.0/16"
    workload_product_a_prd_failover = "10.25.0.0/16"
    workload_product_a_stg_primary  = "10.26.0.0/16"
    workload_product_a_stg_failover = "10.27.0.0/16"
    workload_product_a_tst_primary  = "10.28.0.0/16"
    workload_product_a_tst_failover = "10.29.0.0/16"
    workload_product_a_dev_primary  = "10.30.0.0/16"
    workload_product_a_dev_failover = "10.31.0.0/16"
  }
}

variable "org_owner_email_prefix" {
  description = "the 'jeremybankstech' in 'jeremybankstech+awscloud@gmail.com'"
  default     = "jeremybankstech"
}

variable "org_owner_email_plus_address" {
  description = "the 'awscloud' in 'jeremybankstech+awscloud@gmail.com'"
  default     = "awscloud"
}

variable "org_owner_email_domain_tld" {
  description = "the 'gmail.com' in 'jeremybankstech+awscloud@gmail.com'"
  default     = "gmail.com"
}

variable "company_name" {
  default = "Genovus Labs"
}

variable "company_name_abbr" {
  default = "gn"

  validation {
    condition = (
      var.company_name_abbr != null &&      # not undefined
      var.company_name_abbr != "" &&        # not empty
      length(var.company_name_abbr) >= 1 && # between 1-6 characters
      length(var.company_name_abbr) <= 6 &&
      can(regex("^[a-z0-9]+$", var.company_name_abbr)) # only lowercase letters and numbers
    )
    error_message = "variable 'company_name_abbr' must be defined, consist only of lowercase letters and numbers, and 1-6 characters in length"
  }
}

variable "team_name" {
  default = "devops"
}

variable "team_name_abbr" {
  default = "devops"

  validation {
    condition = (
      var.team_name_abbr != null &&      # not undefined
      var.team_name_abbr != "" &&        # not empty
      length(var.team_name_abbr) >= 1 && # between 1-6 characters
      length(var.team_name_abbr) <= 6 &&
      can(regex("^[a-z0-9]+$", var.team_name_abbr)) # only lowercase letters and numbers
    )
    error_message = "variable 'team_name_abbr' must be defined, consist only of lowercase letters and numbers, and 1-6 characters in length"
  }
}

variable "project_name" {
  default = "Another Final Test Bed"
}

variable "project_name_abbr" {
  default = "aftb"

  validation {
    condition = (
      var.project_name_abbr != null &&      # not undefined
      var.project_name_abbr != "" &&        # not empty
      length(var.project_name_abbr) >= 1 && # between 1-6 characters
      length(var.project_name_abbr) <= 6 &&
      can(regex("^[a-z0-9]+$", var.project_name_abbr)) # only lowercase letters and numbers
    )
    error_message = "variable 'project_name_abbr' must be defined, consist only of lowercase letters and numbers, and 1-6 characters in length"
  }
}

variable "cost_center" {
  default = "1-EU"
}

variable "resource_owner_email" { default = null }

variable "cli_profile_name" { default = "admin" }

variable "provider_role_name" { default = "admin" }

variable "account_role_name" { default = "superadmin" }

variable "admin_role_name" { default = "admin" }

variable "breakglass_user_name" { default = "breakglass" }

variable "billing_user_name" { default = "billing" }

variable "this_slug" {
  default = null

  validation {
    condition = (
      var.this_slug != null &&                  # not undefined
      var.this_slug != "" &&                    # not empty
      can(regex("^[a-z0-9-]+$", var.this_slug)) # only lowercase letters, numbers, and dashes
    )
    error_message = "variable 'this_slug' must be defined, and consist only of lowercase letters, numbers, and dashes"
  }
}

variable "environment" {
  default = "dev"

  validation {
    condition     = contains(["dev", "tst", "stg", "prd"], var.environment)
    error_message = "variable 'environment' must be one of: 'dev', 'tst', 'stg', or 'prd'"
  }
}

variable "org_service_access_principals" {
  type = list(string)
  default = [
    "account.amazonaws.com",                  # account management
    "cloudtrail.amazonaws.com",               # cloudtrail
    "config-multiaccountsetup.amazonaws.com", # config
    "config.amazonaws.com",                   # config
    "ds.amazonaws.com",                       # enterprise active directory
    "ram.amazonaws.com",                      # resource access manager
  ]
}

variable "region_primary" {
  type = map(string)
  default = {
    full  = "us-west-2"
    short = "usw2"
  }
}

variable "region_failover" {
  type = map(string)
  default = {
    full  = "us-east-1"
    short = "use1"
  }
}

variable "create_failover_region_network" { default = true }

variable "create_failover_region" { default = true }

variable "tgw_asn" {
  type = map(number)
  default = {
    primary  = 65434
    failover = 65433
  }
}

variable "vpc_azs_number_used_network" {
  default = 3

  validation {
    condition     = var.vpc_azs_number_used_network >= 2 && var.vpc_azs_number_used_network <= 4
    error_message = "variable 'vpc_azs_number_used_network' must be 2, 3, or 4"
  }
}

variable "vpc_azs_number_used" {
  default = 3

  validation {
    condition     = var.vpc_azs_number_used >= 2 && var.vpc_azs_number_used <= 4
    error_message = "variable 'vpc_azs_number_used' must be 2, 3, or 4"
  }
}

variable "vpc_azs_primary" {
  type = list(string)
  default = [
    "az1",
    "az2",
    "az3",
    # "az4", # firewall not supported
    # "az5", # zone does not exist
    # "az6", # zone does not exist
  ]

  validation {
    condition     = alltrue([for az in var.vpc_azs_primary : can(regex("^az[1-6]$", az))])
    error_message = "variable 'vpc_azs_primary' must be a list of strings matching 'azN' where N is the number 1 through 6"
  }
}

variable "vpc_azs_failover" {
  type = list(string)
  default = [
    "az1",
    "az2",
    # "az3", # firewall not supported
    "az4",
    "az5",
    "az6",
  ]

  validation {
    condition     = alltrue([for az in var.vpc_azs_failover : can(regex("^az[1-6]$", az))])
    error_message = "variable 'vpc_azs_failover' must be a list of strings matching 'azN' where N is the number 1 through 6"
  }
}

variable "vpc_cidr_primary" { default = null }

variable "vpc_cidr_failover" { default = null }

variable "create_vpc_public_subnets" { default = false }

variable "ntp_servers" { default = ["169.254.169.123"] }

variable "log_retention_days" { default = 2192 } # six years per HIPAA NIST SP 800-66 section 4.22

variable "iam_immutable_tag_key" { default = "immutable" }

variable "unique_id_seed" { default = "barFooWorldHello" }

locals {
  # project-env-region-slug
  resource_name = {
    primary  = "${var.project_name_abbr}-${var.environment}-${var.region_primary.short}-${var.this_slug}"
    failover = "${var.project_name_abbr}-${var.environment}-${var.region_failover.short}-${var.this_slug}"
    global   = "${var.project_name_abbr}-${var.environment}-${var.this_slug}"
  }

  # project-env-region-slug-unique
  resource_name_unique = {
    primary  = "${local.resource_name.primary}-${local.unique_id}"
    failover = "${local.resource_name.failover}-${local.unique_id}"
    global   = "${local.resource_name.global}-${local.unique_id}"
  }

  # company-team-project-env-region-slug
  resource_name_full = {
    primary  = "${var.company_name_abbr}-${var.team_name_abbr}-${local.resource_name.primary}"
    failover = "${var.company_name_abbr}-${var.team_name_abbr}-${local.resource_name.failover}"
    global   = "${var.company_name_abbr}-${var.team_name_abbr}-${local.resource_name.global}"
  }

  # company-team-project-env-region-slug-unique
  resource_name_full_unique = {
    primary  = "${local.resource_name_full.primary}-${local.unique_id}"
    failover = "${local.resource_name_full.failover}-${local.unique_id}"
    global   = "${local.resource_name_full.global}-${local.unique_id}"
  }

  vpc_az_ids_primary  = [for az in var.vpc_azs_primary : "${var.region_primary.short}-${az}"]
  vpc_az_ids_failover = [for az in var.vpc_azs_failover : "${var.region_failover.short}-${az}"]

  unique_id = substr(sha256("${var.unique_id_seed}${data.aws_caller_identity.this.account_id}"), 0, 6)

  number_words = { 1 = "one", 2 = "two", 3 = "three", 4 = "four", 5 = "five", 6 = "six", 7 = "seven", 8 = "eight", 9 = "nine", 10 = "ten", }

  org_owner_email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}@${var.org_owner_email_domain_tld}"

  default_tags_map = {
    "${var.company_name_abbr}:company"        = "${var.company_name}"
    "${var.company_name_abbr}:cost_center"    = "${var.cost_center}"
    "${var.company_name_abbr}:environment"    = "${var.environment}"
    "${var.company_name_abbr}:project"        = "${var.project_name}"
    "${var.company_name_abbr}:resource_owner" = var.resource_owner_email != null ? "${var.resource_owner_email}" : "${local.org_owner_email}"
    "${var.company_name_abbr}:team"           = "${var.team_name}"
  }
}