variable "account_id" {
  type = map(string)
  default = {
    networking_prd       = "000000000000"
    workload_spoke_a_prd = "000000000000"
    workload_spoke_b_prd = "000000000000"
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

variable "deployment_environment" {
  type    = string
  default = "dev"

  validation {
    condition     = contains(["dev", "tst", "stg", "prd"], var.deployment_environment)
    error_message = "variable deployment_environment must be one of: 'dev', 'tst', 'stg', or 'prd'"
  }
}

variable "resource_owner_email" {
  description = "point of escalation for ownership"
  type        = string
  default     = ""
}

variable "cli_profile_name" {
  description = "aws profile name to be used"
  type        = string
  default     = "admin"
}

variable "admin_user_names" {
  type = map(string)
  default = {
    superadmin = "superadmin"
    admin      = "admin"
    breakglass = "breakglass"
  }
}

variable "account_role_name" {
  default = "superadmin"
}

variable "admin_role_name" {
  default = "admin"
}

variable "provider_role_name" {
  default = "admin"
}

variable "iam_immutable_tag_key" {
  description = "key used to prevent users from changing critical immutable infrastructure"
  type        = string
  default     = "immutable"
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
  default     = ""

  validation {
    condition     = var.this_slug != null && var.this_slug != ""
    error_message = "variable this_slug must be defined in terraform.tfvars"
  }
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

variable "create_failover_region_networking" {
  type    = bool
  default = true
}

variable "create_failover_region" {
  type    = bool
  default = true
}

variable "azs_primary" {
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

variable "create_vpc_public_subnets" {
  type    = bool
  default = false
}

variable "ntp_servers" {
  type    = list(string)
  default = ["169.254.169.123"]
}

variable "tgw_asn" {
  type = map(number)
  default = {
    primary  = 65434
    failover = 65433
  }
}

# variable "ad_directory_admin_password" {
#   type    = string
#   default = "tempSuperSecretPassword123"
# }

# variable "ad_directory_id_connector_network" {
#   type    = string
#   default = ""
# }

# variable "ad_directory_id_connector_network_failover" {
#   type    = string
#   default = ""
# }

# variable "r53_zones" {
#   type    = list(string)
#   default = []
# }

variable "account_email_slug" {
  type = map(string)
  default = {
    identity_prd         = "identity-prd"
    log_archive_prd      = "log-archive-prd"
    networking_prd       = "network-prd"
    security_tooling_prd = "security-tooling-prd"
    shared_services_prd  = "shared-services-prd"
    shared_services_tst  = "shared-services-tst"
    sdlc_dev             = "sdlc-dev"
    sdlc_tst             = "sdlc-tst"
    sdlc_stg             = "sdlc-stg"
    sdlc_prd             = "sdlc-prd"
    workload_spoke_a_prd = "workload-spoke-a-prd"
    workload_spoke_b_prd = "workload-spoke-b-prd"
  }
}

variable "account_email_substitute" {
  type = map(string)
  default = {
    identity_prd         = ""
    log_archive_prd      = ""
    networking_prd       = ""
    security_tooling_prd = ""
    security_tooling_prd = ""
    shared_services_prd  = ""
    shared_services_tst  = ""
    sdlc_dev             = ""
    sdlc_tst             = ""
    sdlc_stg             = ""
    sdlc_prd             = ""
    workload_spoke_a_prd = ""
    workload_spoke_b_prd = ""
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

    client_vpn_primary  = "10.4.0.0/16"
    client_vpn_failover = "10.5.0.0/16"

    shared_services_prd_primary  = "10.6.0.0/16"
    shared_services_prd_failover = "10.7.0.0/16"
    shared_services_tst_primary  = "10.8.0.0/16"
    shared_services_tst_failover = "10.9.0.0/16"

    sdlc_dev_primary  = "10.10.0.0/16"
    sdlc_dev_failover = "10.11.0.0/16"
    sdlc_tst_primary  = "10.12.0.0/16"
    sdlc_tst_failover = "10.13.0.0/16"
    sdlc_stg_primary  = "10.14.0.0/16"
    sdlc_stg_failover = "10.15.0.0/16"
    sdlc_prd_primary  = "10.16.0.0/16"
    sdlc_prd_failover = "10.17.0.0/16"

    workload_spoke_a_prd_primary  = "10.18.0.0/16"
    workload_spoke_a_prd_failover = "10.19.0.0/16"

    workload_spoke_b_prd_primary  = "10.20.0.0/16"
    workload_spoke_b_prd_failover = "10.21.0.0/16"
  }
}

locals {
  org_owner_email = "${var.org_owner_email_prefix}@${var.org_owner_email_domain_tld}"

  account_owner_email = {
    identity_prd         = var.account_email_substitute.identity_prd != "" ? var.account_email_substitute.identity_prd : "${var.org_owner_email_prefix}-${var.account_email_slug.identity_prd}@${var.org_owner_email_domain_tld}"
    log_archive_prd      = var.account_email_substitute.log_archive_prd != "" ? var.account_email_substitute.log_archive_prd : "${var.org_owner_email_prefix}-${var.account_email_slug.log_archive_prd}@${var.org_owner_email_domain_tld}"
    networking_prd       = var.account_email_substitute.networking_prd != "" ? var.account_email_substitute.networking_prd : "${var.org_owner_email_prefix}-${var.account_email_slug.networking_prd}@${var.org_owner_email_domain_tld}"
    security_tooling_prd = var.account_email_substitute.security_tooling_prd != "" ? var.account_email_substitute.security_tooling_prd : "${var.org_owner_email_prefix}-${var.account_email_slug.security_tooling_prd}@${var.org_owner_email_domain_tld}"
    workload_spoke_a_prd = var.account_email_substitute.workload_spoke_a_prd != "" ? var.account_email_substitute.workload_spoke_a_prd : "${var.org_owner_email_prefix}-${var.account_email_slug.workload_spoke_a_prd}@${var.org_owner_email_domain_tld}"
    workload_spoke_b_prd = var.account_email_substitute.workload_spoke_b_prd != "" ? var.account_email_substitute.workload_spoke_b_prd : "${var.org_owner_email_prefix}-${var.account_email_slug.workload_spoke_b_prd}@${var.org_owner_email_domain_tld}"
  }

  resource_name_stub          = lower("${var.company_name_abbr}-${var.team_name_abbr}-${var.project_name_abbr}") #company - team - project - env
  resource_name_stub_primary  = lower("${local.resource_name_stub}-${var.region_primary.short}")                 #company - team - project - env - primary
  resource_name_stub_failover = lower("${local.resource_name_stub}-${var.region_failover.short}")                #company - team - project - env - failover

  number_words = { 1 = "one", 2 = "two", 3 = "three", 4 = "four", 5 = "five", 6 = "six", 7 = "seven", 8 = "eight", 9 = "nine", 10 = "ten", }

  # vpc_tags_primary = merge(local.eks_tags_primary, {
  #   "${local.resource_name_stub_primary}-blue"                            = "shared"
  #   "${local.resource_name_stub_primary}-green"                           = "shared"
  #   "k8s.io/cluster-autoscaler/${local.resource_name_stub_primary}-blue"  = "shared"
  #   "k8s.io/cluster-autoscaler/${local.resource_name_stub_primary}-green" = "shared"
  #   "k8s.io/cluster-autoscaler/enabled"                                   = "true"
  # })
  # vpc_tags_failover = merge(local.eks_tags_failover, {
  #   "${local.resource_name_stub_failover}-blue"                            = "shared"
  #   "${local.resource_name_stub_failover}-green"                           = "shared"
  #   "k8s.io/cluster-autoscaler/${local.resource_name_stub_failover}-blue"  = "shared"
  #   "k8s.io/cluster-autoscaler/${local.resource_name_stub_failover}-green" = "shared"
  #   "k8s.io/cluster-autoscaler/enabled"                                    = "true"
  # })

  # subnet_pvt_tags_primary  = merge(local.eks_tags_primary, local.eks_tags_subnet_pvt)
  # subnet_pub_tags_primary  = merge(local.eks_tags_primary, local.eks_tags_subnet_pub)
  # subnet_pvt_tags_failover = merge(local.eks_tags_failover, local.eks_tags_subnet_pvt)
  # subnet_pub_tags_failover = merge(local.eks_tags_failover, local.eks_tags_subnet_pub)

  # eks_tags_primary = {
  #   "kubernetes.io/cluster/${local.resource_name_stub_primary}-blue"  = "shared"
  #   "kubernetes.io/cluster/${local.resource_name_stub_primary}-green" = "shared"
  # }
  # eks_tags_failover = {
  #   "kubernetes.io/cluster/${local.resource_name_stub_failover}-blue"  = "shared"
  #   "kubernetes.io/cluster/${local.resource_name_stub_failover}-green" = "shared"
  # }

  # eks_tags_subnet_pvt = {
  #   "kubernetes.io/role/alb-ingress"  = 1
  #   "kubernetes.io/role/internal-elb" = 1
  # }
  # eks_tags_subnet_pub = {
  #   "kubernetes.io/role/alb-ingress" = 1
  #   "kubernetes.io/role/elb"         = 1
  # }

  default_tags_map = {
    "company"                      = "${var.company_name}"
    "team"                         = "${var.team_name}"
    "cost_center"                  = "${var.cost_center}"
    "project"                      = "${var.project_name}"
    "environment"                  = "${var.deployment_environment}"
    "resource_owner"               = var.resource_owner_email != "" ? "${var.resource_owner_email}" : "${local.org_owner_email}"
    "${var.iam_immutable_tag_key}" = "true"
  }
}