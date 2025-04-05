variable "account_id" {
  type = map(string)
  default = {
    # identity_prd         = ""
    # log_archive_prd      = ""
    network_prd = "421954349749"
    # management           = ""
    # sdlc_dev             = ""
    # sdlc_prd             = ""
    # sdlc_stg             = ""
    # sdlc_tst             = ""
    # security_tooling_prd = ""
  }
}

variable "org_owner_email_prefix" {
  description = "the 'billg+aws' in 'billg+aws@microsoft.com'"
  type        = string
  default     = "workjeremyb+newtestbed"
}

variable "org_owner_email_domain_tld" {
  description = "the 'microsoft.com' in 'billg+aws@microsoft.com'"
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
  description = "name of the deployment environment, eg dev, tst, stg, prd"
  type        = string
  default     = "dev"
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
  description = "key used to prevent users from editing IaC"
  type        = string
  default     = "immutable"
}

variable "org_service_access_principals" {
  type = list(string)
  default = [
    "account.amazonaws.com", #account management
    "cloudtrail.amazonaws.com",
    "config-multiaccountsetup.amazonaws.com",
    "config.amazonaws.com",
    "ds.amazonaws.com", #enterprise active directory
    "ram.amazonaws.com",
  ]
}

variable "this_slug" {
  description = "used to programatically declare resource names"
  type        = string
  default     = "YOU-FORGOT-TO-DECLARE-VARIABLE-this_slug-AND-AS-A-RESULT-THIS-STRING-IS-SO-LONG-IT-WILL-HOPEFULLY-FAIL-ANY-RESOURCE-CREATE-THUS-PROMPTING-YOU-TO-DEFINE-IT-IN-terraform.tfvars"
}

variable "region" {
  description = "regions for the infrastructure"
  type        = map(string)
  default = {
    primary        = "us-west-2"
    failover       = "us-east-1"
    primary_short  = "usw2"
    failover_short = "use1"
  }
}

variable "create_failover_region" {
  type    = bool
  default = false
}

variable "azs_primary" {
  description = "availability zones to use"
  default = [
    "usw2-az1",
    # "usw2-az4", firewall-fips not supported
    "usw2-az2",
    "usw2-az3",
  ]
}

variable "azs_failover" {
  default = [
    # "use1-az5", firewall-fips not supported
    "use1-az2",
    "use1-az1",
    # "use1-az4", firewall-fips not supported
    # "use1-az3", firewall-fips not supported
    "use1-az6",
  ]
}

variable "azs_used" {
  description = "this codebase supports 2, 3, or 4 availability zones"
  type        = number
  default     = 2
}

variable "network_tgw_share_enabled" {
  type    = bool
  default = false
}

variable "vpc_cidr_substitute" {
  description = "Primary Region VPC CIDR. Use the full network address and subnet mask, eg 10.31.0.0/16"
  type        = string
  default     = ""
}

variable "vpc_cidr_substitute_failover" {
  description = "Failover Region VPC CIDR. Use the full network address and subnet mask, eg 10.32.0.0/16"
  type        = string
  default     = ""
}

variable "vpc_cidr_network_primary" {
  default = {
    inbound    = "10.0.0.0/16"
    outbound   = "10.1.0.0/16"
    inspection = "10.2.0.0/16"
  }
}

variable "vpc_cidr_network_failover" {
  default = {
    inbound    = "10.3.0.0/16"
    outbound   = "10.4.0.0/16"
    inspection = "10.5.0.0/16"
  }
}

variable "vpc_endpoint_services_enabled" {
  type = list(string)
  default = [
    # "dynamodb",
    # "ec2",
    # "kms",
    # "s3",
  ]
}

variable "network_vpc_share_enabled" {
  type    = bool
  default = false
}

variable "vpc_cidr_clientvpn" {
  default = {
    primary  = "10.43.0.0/16"
    failover = "10.44.0.0/16"
  }
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

variable "ad_directory_admin_password" {
  type    = string
  default = "tempSuperSecretPassword123"
}

variable "ad_directory_id_connector_network" {
  type    = string
  default = ""
}

variable "ad_directory_id_connector_network_failover" {
  type    = string
  default = ""
}

variable "r53_zones" {
  type    = list(string)
  default = []
}

variable "account_email_slug" {
  type = map(string)
  default = {
    identity_prd         = "identity-prd"
    log_archive_prd      = "log_archive_prd"
    network_prd          = "network-prd"
    security_tooling_prd = "security_tooling_prd"
  }
}

variable "account_email_substitute" {
  type = map(string)
  default = {
    identity_prd         = ""
    log_archive_prd      = ""
    network_prd          = ""
    security_tooling_prd = ""
  }
}

variable "vpc_cidr_infrastructure" {
  type = map(string)
  default = {
    transit_gateway     = "10.0.0.0/8"
    inbound_failover    = "10.3.0.0/16"
    inbound_primary     = "10.0.0.0/16"
    inspection_failover = "10.4.0.0/16"
    inspection_primary  = "10.1.0.0/16"
    outbound_failover   = "10.5.0.0/16"
    outbound_primary    = "10.2.0.0/16"
  }
}

locals {
  org_owner_email = "${var.org_owner_email_prefix}@${var.org_owner_email_domain_tld}"

  account_owner_email = {
    identity_prd         = var.account_email_substitute.identity_prd != "" ? var.account_email_substitute.identity_prd : "${var.org_owner_email_prefix}-${var.account_email_slug.identity_prd}@${var.org_owner_email_domain_tld}"
    log_archive_prd      = var.account_email_substitute.log_archive_prd != "" ? var.account_email_substitute.log_archive_prd : "${var.org_owner_email_prefix}-${var.account_email_slug.log_archive_prd}@${var.org_owner_email_domain_tld}"
    network_prd          = var.account_email_substitute.network_prd != "" ? var.account_email_substitute.network_prd : "${var.org_owner_email_prefix}-${var.account_email_slug.network_prd}@${var.org_owner_email_domain_tld}"
    security_tooling_prd = var.account_email_substitute.security_tooling_prd != "" ? var.account_email_substitute.security_tooling_prd : "${var.org_owner_email_prefix}-${var.account_email_slug.security_tooling_prd}@${var.org_owner_email_domain_tld}"
  }

  resource_name_stub          = lower("${var.company_name_abbr}-${var.team_name_abbr}-${var.project_name_abbr}") #company - team - project - env
  resource_name_stub_primary  = lower("${local.resource_name_stub}-${var.region.primary_short}")                 #company - team - project - env - primary
  resource_name_stub_failover = lower("${local.resource_name_stub}-${var.region.failover_short}")                #company - team - project - env - failover

  azs_primary  = slice(var.azs_primary, 0, var.azs_used)
  azs_failover = slice(var.azs_failover, 0, var.azs_used)


  # #build lists of availability zones for each region based on number of availabiliy zones
  # # azs_used_list_primary  = [for az in range(var.availability_zones_num_used) : var.availability_zones.primary[az]]
  # azs_used_list_failover = [for az in range(var.availability_zones_num_used) : var.availability_zones.failover[az]]

  # #dynamically generate subnet cidrs based on number of availability zones
  # vpc_subnet_cidrs_primary = local.vpc_cidr_primary != "" ? (
  #   var.availability_zones_num_used == 6 ? cidrsubnets(local.vpc_cidr_primary, 3, 3, 3, 3, 3, 3, 5, 5, 5, 5, 5, 5) :
  #   var.availability_zones_num_used == 5 ? cidrsubnets(local.vpc_cidr_primary, 3, 3, 3, 3, 3, 5, 5, 5, 5, 5) :
  #   var.availability_zones_num_used == 4 ? cidrsubnets(local.vpc_cidr_primary, 3, 3, 3, 3, 5, 5, 5, 5) :
  #   var.availability_zones_num_used == 3 ? cidrsubnets(local.vpc_cidr_primary, 2, 2, 2, 4, 4, 4) :
  #   cidrsubnets(local.vpc_cidr_primary, 2, 2, 4, 4)
  # ) : []
  # vpc_subnet_cidrs_failover = local.vpc_cidr_failover != "" ? (
  #   var.availability_zones_num_used == 6 ? cidrsubnets(local.vpc_cidr_failover, 3, 3, 3, 3, 3, 3, 5, 5, 5, 5, 5, 5) :
  #   var.availability_zones_num_used == 5 ? cidrsubnets(local.vpc_cidr_failover, 3, 3, 3, 3, 3, 5, 5, 5, 5, 5) :
  #   var.availability_zones_num_used == 4 ? cidrsubnets(local.vpc_cidr_failover, 3, 3, 3, 3, 5, 5, 5, 5) :
  #   var.availability_zones_num_used == 3 ? cidrsubnets(local.vpc_cidr_failover, 2, 2, 2, 4, 4, 4) :
  #   cidrsubnets(local.vpc_cidr_failover, 2, 2, 4, 4)
  # ) : []

  # #slice the subnets in 'half', first slice goes to pvt, second slice goes to pub
  # vpc_subnet_cidrs_pvt_primary  = slice(local.vpc_subnet_cidrs_primary, 0, length(local.vpc_subnet_cidrs_primary) / 2)
  # vpc_subnet_cidrs_pub_primary  = slice(local.vpc_subnet_cidrs_primary, length(local.vpc_subnet_cidrs_primary) / 2, length(local.vpc_subnet_cidrs_primary))
  # vpc_subnet_cidrs_pvt_failover = slice(local.vpc_subnet_cidrs_failover, 0, length(local.vpc_subnet_cidrs_failover) / 2)
  # vpc_subnet_cidrs_pub_failover = slice(local.vpc_subnet_cidrs_failover, length(local.vpc_subnet_cidrs_failover) / 2, length(local.vpc_subnet_cidrs_failover))

  # #create addresses for VPC DNS
  # vpc_dns_primary = local.vpc_cidr_primary != "" ? join(".", [
  #   split(".", cidrhost(local.vpc_cidr_primary, 0))[0],
  #   split(".", cidrhost(local.vpc_cidr_primary, 0))[1],
  #   split(".", cidrhost(local.vpc_cidr_primary, 0))[2],
  #   "2"
  # ]) : local.vpc_cidr_primary
  # vpc_dns_failover = local.vpc_cidr_failover != "" ? join(".", [
  #   split(".", cidrhost(local.vpc_cidr_failover, 0))[0],
  #   split(".", cidrhost(local.vpc_cidr_failover, 0))[1],
  #   split(".", cidrhost(local.vpc_cidr_failover, 0))[2],
  #   "2"
  # ]) : local.vpc_cidr_failover

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

  # acm_san_names = concat(
  #   [
  #     for zone in var.r53_zones :
  #     (var.deployment_environment != "prd" ? "${var.deployment_environment}.${zone}" : zone)
  #   ],
  #   [
  #     for zone in var.r53_zones :
  #     (var.deployment_environment != "prd" ? "*.${var.deployment_environment}.${zone}" : "*.${zone}")
  #   ]
  # )

  default_tags_map = {
    "company"                      = "${var.company_name}" #Microsoft
    "team"                         = "${var.team_name}"    #Blue
    "cost_center"                  = "${var.cost_center}"
    "project"                      = "${var.project_name}"           #Windows
    "environment"                  = "${var.deployment_environment}" #dev|tst|stg|prd
    "resource_owner"               = var.resource_owner_email != "" ? "${var.resource_owner_email}" : "${local.org_owner_email}"
    "${var.iam_immutable_tag_key}" = "true"
  }
}