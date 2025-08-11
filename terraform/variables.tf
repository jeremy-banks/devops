variable "account_id" {
  type = map(string)
  default = {
    identity_prd         = "000000000000"
    log_archive_prd      = "000000000000"
    networking_prd       = "000000000000"
    security_tooling_prd = "000000000000"

    workload_shared_services_prd = "000000000000"
    workload_shared_services_stg = "000000000000"

    workload_sdlc_prd = "000000000000"
    workload_sdlc_stg = "000000000000"
    workload_sdlc_tst = "000000000000"
    workload_sdlc_dev = "000000000000"

    workload_product_a_dev = "000000000000"
    workload_product_a_prd = "000000000000"
    workload_product_a_stg = "000000000000"
    workload_product_a_tst = "000000000000"

    workload_customer_a_prd = "000000000000"
    workload_customer_a_stg = "000000000000"
  }
}

variable "account_name_slug" {
  type = map(string)
  default = {
    identity_prd         = "identity-prd"
    log_archive_prd      = "log-archive-prd"
    networking_prd       = "network-prd"
    security_tooling_prd = "security-tooling-prd"

    workload_shared_services_prd = "workload-shared-services-prd"
    workload_shared_services_stg = "workload-shared-services-stg"

    workload_sdlc_prd = "workload-sdlc-prd"
    workload_sdlc_stg = "workload-sdlc-stg"
    workload_sdlc_tst = "workload-sdlc-tst"
    workload_sdlc_dev = "workload-sdlc-dev"

    workload_product_a_prd = "workload-product-a-prd"
    workload_product_a_stg = "workload-product-a-stg"
    workload_product_a_tst = "workload-product-a-tst"
    workload_product_a_dev = "workload-product-a-dev"

    workload_customer_a_prd = "workload-customer-a-prd"
    workload_customer_a_stg = "workload-customer-a-stg"
  }
}

variable "vpc_cidr_infrastructure" {
  type = map(string)
  default = {
    transit_gateway = "10.0.0.0/8"

    central_inspection_primary  = "10.0.0.0/16"
    central_inspection_failover = "10.1.0.0/16"
    central_egress_primary      = "10.2.0.0/16"
    central_egress_failover     = "10.3.0.0/16"

    client_vpn_prd_primary  = "10.4.0.0/16"
    client_vpn_prd_failover = "10.5.0.0/16"
    client_vpn_stg_primary  = "10.6.0.0/16"
    client_vpn_stg_failover = "10.7.0.0/16"

    workload_shared_services_prd_primary  = "10.8.0.0/16"
    workload_shared_services_prd_failover = "10.9.0.0/16"
    workload_shared_services_stg_primary  = "10.10.0.0/16"
    workload_shared_services_stg_failover = "10.11.0.0/16"

    workload_sdlc_prd_primary  = "10.12.0.0/16"
    workload_sdlc_prd_failover = "10.13.0.0/16"
    workload_sdlc_stg_primary  = "10.14.0.0/16"
    workload_sdlc_stg_failover = "10.15.0.0/16"
    workload_sdlc_tst_primary  = "10.16.0.0/16"
    workload_sdlc_tst_failover = "10.17.0.0/16"
    workload_sdlc_dev_primary  = "10.18.0.0/16"
    workload_sdlc_dev_failover = "10.19.0.0/16"

    workload_product_a_prd_primary  = "10.20.0.0/16"
    workload_product_a_prd_failover = "10.21.0.0/16"
    workload_product_a_stg_primary  = "10.22.0.0/16"
    workload_product_a_stg_failover = "10.23.0.0/16"
    workload_product_a_tst_primary  = "10.24.0.0/16"
    workload_product_a_tst_failover = "10.25.0.0/16"
    workload_product_a_dev_primary  = "10.26.0.0/16"
    workload_product_a_dev_failover = "10.27.0.0/16"

    workload_customer_a_prd_primary  = "10.28.0.0/16"
    workload_customer_a_prd_failover = "10.29.0.0/16"
    workload_customer_a_stg_primary  = "10.30.0.0/16"
    workload_customer_a_stg_failover = "10.31.0.0/16"
  }
}

variable "org_owner_email_prefix" {
  description = "the 'jeremybankstech+newtestbed' in 'jeremybankstech+newtestbed@gmail.com'"
  type        = string
  default     = "jeremybankstech+newtestbed"
}

variable "org_owner_email_domain_tld" {
  description = "the 'gmail.com' in 'jeremybankstech+newtestbed@gmail.com'"
  type        = string
  default     = "gmail.com"
}

variable "company_name" {
  description = "name of the company"
  type        = string
  default     = "Photon Craze"
}

variable "company_name_abbr" {
  type    = string
  default = "pc"
}

variable "team_name" {
  description = "name of the team"
  type        = string
  default     = "devops"
}

variable "team_name_abbr" {
  type    = string
  default = "devops"
}

variable "project_name" {
  description = "name of the project"
  type        = string
  default     = "newtestbed"
}

variable "project_name_abbr" {
  type    = string
  default = "ntb"
}

variable "cost_center" {
  description = "for billing"
  type        = string
  default     = "1-EU"
}

variable "resource_owner_email" {
  description = "point of escalation for ownership"
  type        = string
  default     = null
}

variable "admin_user_names" {
  type = map(string)
  default = {
    superadmin = "superadmin"
    admin      = "admin"
    breakglass = "breakglass"
  }
}

variable "cli_profile_name" {
  type    = string
  default = "admin"
}

variable "account_role_name" {
  type    = string
  default = "superadmin"
}

variable "admin_role_name" {
  type    = string
  default = "admin"
}

variable "provider_role_name" {
  type    = string
  default = "admin"
}

variable "org_service_access_principals" {
  type = list(string)
  default = [
    "account.amazonaws.com",                  #account management
    "cloudtrail.amazonaws.com",               #cloudtrail
    "config-multiaccountsetup.amazonaws.com", #config
    "config.amazonaws.com",                   #config
    "ds.amazonaws.com",                       #enterprise active directory
    "ram.amazonaws.com",                      #resource access manager
  ]
}

variable "this_slug" {
  description = "used to programatically declare resource names"
  type        = string
  default     = null

  validation {
    condition = (
      var.this_slug != null &&                     #not undefined
      var.this_slug != "" &&                       #not empty
      can(regex("^[a-zA-Z0-9-]+$", var.this_slug)) #only has alphanumerics and dashes
    )
    error_message = "variable this_slug must be defined in terraform.tfvars, as alphanumerics and dashes only"
  }
}

variable "deployment_environment" {
  type    = string
  default = "dev"

  validation {
    condition     = contains(["dev", "tst", "stg", "prd"], var.deployment_environment)
    error_message = "variable deployment_environment must be one of: 'dev', 'tst', 'stg', or 'prd'"
  }
}

variable "tgw_asn" {
  type = map(number)
  default = {
    primary  = 65434
    failover = 65433
  }
}

variable "create_failover_region_networking" {
  type    = bool
  default = true
}

variable "create_failover_region" {
  type    = bool
  default = true
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

variable "azs_number_used_networking" {
  type    = number
  default = 3

  validation {
    condition     = var.azs_number_used_networking >= 2 && var.azs_number_used_networking <= 4
    error_message = "this codebase supports 2, 3, or 4 availability zones"
  }
}

variable "azs_number_used" {
  type    = number
  default = 3

  validation {
    condition     = var.azs_number_used >= 2 && var.azs_number_used <= 4
    error_message = "this codebase supports 2, 3, or 4 availability zones"
  }
}

variable "azs_primary" {
  type = list(string)
  default = [
    "usw2-az1",
    "usw2-az2",
    "usw2-az3",
    "usw2-az4", # firewall not supported
  ]

  validation {
    condition     = alltrue([for az in var.azs_primary : can(regex("^us[a-z0-9]+-az[0-9]+$", az))])
    error_message = "must be AWS AZ IDs like 'usw2-az1', not AZ names like 'us-east-1a'"
  }
}

variable "azs_failover" {
  type = list(string)
  default = [
    "use1-az1",
    "use1-az2",
    "use1-az4",
    "use1-az5",
    "use1-az6",
    "use1-az3", # firewall not supported
  ]

  validation {
    condition     = alltrue([for az in var.azs_failover : can(regex("^[a-z0-9-]+-az[0-9]+$", az))])
    error_message = "must be AWS AZ IDs like 'usw2-az1' or 'sae1-az1', not AZ names like 'us-east-1a'"
  }
}

variable "vpc_cidr_primary" {
  type    = string
  default = null
}

variable "vpc_cidr_failover" {
  type    = string
  default = null
}

variable "create_vpc_public_subnets" {
  type    = bool
  default = false
}

variable "ntp_servers" {
  type    = list(string)
  default = ["169.254.169.123"]
}

variable "r53_zones_parents" {
  type    = list(string)
  default = null
}

variable "r53_zones_delegates_stg" {
  type    = list(string)
  default = null
}

variable "r53_zones_delegates_tst" {
  type    = list(string)
  default = null
}

variable "r53_zones_delegates_dev" {
  type    = list(string)
  default = null
}

variable "log_retention_days" {
  type    = number
  default = 2192 #six years per HIPAA NIST SP 800-66 section 4.22
}

variable "iam_immutable_tag_key" {
  description = "key used to prevent users from changing critical immutable infrastructure"
  type        = string
  default     = "immutable"
}

variable "unique_id_seed" {
  default = "foo"
}

locals {
  org_owner_email = "${var.org_owner_email_prefix}@${var.org_owner_email_domain_tld}"

  # company-project
  resource_name_prefix = lower("${var.company_name_abbr}-${var.project_name_abbr}")

  # company-project-region-env-slug
  resource_name_primary  = lower("${local.resource_name_prefix}-${var.region_primary.short}-${var.deployment_environment}-${var.this_slug}")
  resource_name_failover = lower("${local.resource_name_prefix}-${var.region_failover.short}-${var.deployment_environment}-${var.this_slug}")

  # company-project-region-env-slug-unique_id
  resource_name_primary_globally_unique  = "${local.resource_name_primary}-${local.unique_id}"
  resource_name_failover_globally_unique = "${local.resource_name_failover}-${local.unique_id}"

  # this_slug_prd = join("_", ["workload", replace(var.this_slug, "-", "_"), "prd"])
  # this_slug_stg = join("_", ["workload", replace(var.this_slug, "-", "_"), "stg"])
  # this_slug_tst = join("_", ["workload", replace(var.this_slug, "-", "_"), "tst"])
  # this_slug_dev = join("_", ["workload", replace(var.this_slug, "-", "_"), "dev"])

  # this_snake          = join("_", ["workload", replace(var.this_slug, "-", "_"), var.deployment_environment])
  # this_snake_primary  = join("_", ["workload", replace(var.this_slug, "-", "_"), var.deployment_environment, "primary"])
  # this_snake_failover = join("_", ["workload", replace(var.this_slug, "-", "_"), var.deployment_environment, "failover"])

  unique_id = substr(sha256("${var.unique_id_seed}${data.aws_caller_identity.this.account_id}"), 0, 8)

  number_words = { 1 = "one", 2 = "two", 3 = "three", 4 = "four", 5 = "five", 6 = "six", 7 = "seven", 8 = "eight", 9 = "nine", 10 = "ten", }

  default_tags_map = {
    "${var.company_name_abbr}:company"        = "${var.company_name}"
    "${var.company_name_abbr}:team"           = "${var.team_name}"
    "${var.company_name_abbr}:cost_center"    = "${var.cost_center}"
    "${var.company_name_abbr}:project"        = "${var.project_name}"
    "${var.company_name_abbr}:environment"    = "${var.deployment_environment}"
    "${var.company_name_abbr}:resource_owner" = var.resource_owner_email != null ? "${var.resource_owner_email}" : "${local.org_owner_email}"

    "${var.company_name_abbr}:${var.iam_immutable_tag_key}" = "true"
  }
}