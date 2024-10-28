variable "account_id" {
  type    = map(string)
  default = {
    identity = ""
    log_archive = ""
    network = ""
    org = ""
    sdlc_dev = ""
    sdlc_prd = ""
    sdlc_stg = ""
    sdlc_tst = ""
    security_tooling = ""
  }
}

variable "org_owner_email_prefix" {
  description = "the 'billg' in 'billg@microsoft'"
  type        = string
  default     = "billg"
}

variable "org_owner_email_domain_tld" {
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
  type    = string
  default = "scc"
}

variable "team_name" {
  description = "name of the team"
  type        = string
  default     = "blue"
}

variable "team_name_abbr" {
  type    = string
  default = "blue"
}

variable "project_name" {
  description = "name of the project"
  type        = string
  default     = "windows12"
}

variable "project_name_abbr" {
  type    = string
  default = "w12"
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

variable "this_slug" {
  description = "used to programatically declare resource names"
  type        = string
  default     = "YOU-FORGOT-TO-DECLARE-this_slug-AND-AS-A-RESULT-THIS-STRING-IS-SO-LONG-IT-WILL-HOPEFULLY-FAIL-PROMPTING-YOU-TO-DEFINE-IT"
}

variable "cli_profile_name_aws" {
  description = "aws profile name to be used"
  type        = string
  default     = "automation"
}

variable "assumable_roles_name" {
  type    = map(string)
  default = {
    admin     = "admin"
    poweruser = "poweruser"
    readonly  = "readonly"
  }
}

variable "assumable_role_name" {
  type    = map(string)
  default = {
    superadmin  = "superadmin"
    automation  = "automation"
  }
}

variable "provider_role_name" {
  type    = string
  default = "automation"
}

variable "iam_access_management_tag_key" {
  description = "prevents changing any resources created with IaC tools"
  type        = string
  default     = "iam_access_management"
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
  type    = map(list(string))
  default = {
    primary = [
      "usw2-az1",
      "usw2-az4",
      "usw2-az3",
      "usw2-az2",
    ]
    failover = [
      "use1-az5",
      "use1-az2",
      "use1-az4",
      "use1-az1",
    ]
  }
}

variable "availability_zones_used" {
  type    = number
  default = 2
}

variable "network_tgw_share_enabled" {
  type    = bool
  default = false
}

variable "network_vpc_endpoint_services_enabled" {
  description = "ec2, rds, s3..."
  type        = list(string)
  default     = [""]
}

variable "network_vpc_share_enabled" {
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

variable "vpc_cidr_network" {
  default = {
    primary = "10.41.0.0/16"
    failover = "10.42.0.0/16"
  }
}

variable "vpc_cidr_clientvpn" {
  default = {
    primary   = "10.43.0.0/16"
    failover  = "10.44.0.0/16"
  }
}

variable "ntp_server" {
  type    = string
  default = "169.254.169.123"
}

variable "tgw_asn" {
  type    = map(number)
  default = {
    primary = 65434
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

output "fooo" {
  value = local.vpc_subnet_cidrs_primary
}

output "bar" {
  value = local.vpc_cidr_failover
}

locals {
  cli_profile_name_aws = var.cli_profile_name_aws
  provider_role_name = var.provider_role_name

  org_owner_email = "${var.org_owner_email_prefix}@${var.org_owner_email_domain_tld}"
  resource_owner_email = var.resource_owner_email != "" ? var.resource_owner_email : local.org_owner_email

  resource_name_stub          = lower("${var.company_name_abbr}-${var.team_name_abbr}-${var.project_name_abbr}") #company - team - project - env
  resource_name_stub_primary  = lower("${var.company_name_abbr}-${var.team_name_abbr}-${var.project_name_abbr}-${var.region.primary_short}") #company - team - project - env
  resource_name_stub_failover = lower("${var.company_name_abbr}-${var.team_name_abbr}-${var.project_name_abbr}-${var.region.failover_short}") #company - team - project - env
  this_slug = "${var.this_slug}"

#make all possible results
#select right one based on AZs
#copy primary into failover and reformat prefix for failover
#split each into pvt/pub as needed
#supply directly to vpc_subnet_cidrs_pvt_primary
#rename vpc_subnet_cidrs_pvt_primary

  vpc_cidr_primary = var.vpc_cidr_substitute
  # increment major subnet for failover
  vpc_cidr_failover = join(".", [split(".", var.vpc_cidr_substitute)[0], tostring(tonumber(split(".", var.vpc_cidr_substitute)[1]) + 1), split(".", var.vpc_cidr_substitute)[2], split(".", var.vpc_cidr_substitute)[3]])

  vpc_subnet_cidrs_primary = local.vpc_cidr_primary != "" ? (
    var.availability_zones_used == 6 ? cidrsubnets(local.vpc_cidr_primary, 3, 3, 3, 3, 3, 3, 5, 5, 5, 5, 5, 5) :
    var.availability_zones_used == 5 ? cidrsubnets(local.vpc_cidr_primary, 3, 3, 3, 3, 3, 5, 5, 5, 5, 5) :
    var.availability_zones_used == 4 ? cidrsubnets(local.vpc_cidr_primary, 3, 3, 3, 3, 5, 5, 5, 5) :
    var.availability_zones_used == 3 ? cidrsubnets(local.vpc_cidr_primary, 2, 2, 2, 4, 4, 4) :
    cidrsubnets(local.vpc_cidr_primary, 2, 2, 4, 4)
  ) : []

  vpc_subnet_cidrs_failover = local.vpc_cidr_primary != "" ? (
    var.availability_zones_used == 6 ? cidrsubnets(local.vpc_cidr_primary, 3, 3, 3, 3, 3, 3, 5, 5, 5, 5, 5, 5) :
    var.availability_zones_used == 5 ? cidrsubnets(local.vpc_cidr_primary, 3, 3, 3, 3, 3, 5, 5, 5, 5, 5) :
    var.availability_zones_used == 4 ? cidrsubnets(local.vpc_cidr_primary, 3, 3, 3, 3, 5, 5, 5, 5) :
    var.availability_zones_used == 3 ? cidrsubnets(local.vpc_cidr_primary, 2, 2, 2, 4, 4, 4) :
    cidrsubnets(local.vpc_cidr_primary, 2, 2, 4, 4)
  ) : []

  vpc_subnet_newbits_pvt = length(local.vpc_azs_primary) < 4 ? 2 : 3
  vpc_subnet_newbits_pub = length(local.vpc_azs_primary) < 4 ? 4 : 5

  vpc_azs_primary = var.availability_zones.primary
  vpc_subnet_cidrs_pvt_primary = [for i in range(length(local.vpc_azs_primary)) : cidrsubnet(local.vpc_cidr_primary, local.vpc_subnet_newbits_pvt, i)]
  vpc_subnet_cidrs_pub_primary = [for i in range(length(local.vpc_azs_primary)) : cidrsubnet(local.vpc_cidr_primary, local.vpc_subnet_newbits_pub + 1, length(local.vpc_azs_primary) + i)]

  vpc_cidr_primary_split = split(".", cidrsubnet(local.vpc_cidr_primary, 0, 0))
  vpc_dns_primary = join(".", [local.vpc_cidr_primary_split[0], local.vpc_cidr_primary_split[1], local.vpc_cidr_primary_split[2], "2"])

  vpc_azs_failover = var.availability_zones.failover
  vpc_subnet_cidrs_pvt_failover = [for i in range(length(local.vpc_azs_primary)) : cidrsubnet(local.vpc_cidr_failover, local.vpc_subnet_newbits_pvt, i)]
  vpc_subnet_cidrs_pub_failover = [for i in range(length(local.vpc_azs_primary)) : cidrsubnet(local.vpc_cidr_failover, local.vpc_subnet_newbits_pub + 1, length(local.vpc_azs_primary) + i)]
  vpc_cidr_failover_split = split(".", cidrsubnet(local.vpc_cidr_failover, 0, 0))
  vpc_dns_failover = join(".", [local.vpc_cidr_failover_split[0], local.vpc_cidr_failover_split[1], local.vpc_cidr_failover_split[2], "2"])

  vpc_ntp_servers = [var.ntp_server]

  k8s_tags_primary = {
    "kubernetes.io/cluster/${local.resource_name_stub_primary}-blue"  = "shared"
    "kubernetes.io/cluster/${local.resource_name_stub_primary}-green" = "shared"
  }
  k8s_tags_failover = {
    "kubernetes.io/cluster/${local.resource_name_stub_failover}-blue"  = "shared"
    "kubernetes.io/cluster/${local.resource_name_stub_failover}-green" = "shared"
  }
  k8s_tags_subnet_pub = {
    "kubernetes.io/role/alb-ingress"  = 1
    "kubernetes.io/role/elb"          = 1    
  }
  k8s_tags_subnet_pvt = {
    "kubernetes.io/role/alb-ingress"  = 1
    "kubernetes.io/role/internal-elb" = 1
  }

  vpc_tags_primary = merge(local.k8s_tags_primary, {
    "${local.resource_name_stub_primary}-blue"  = "shared"
    "${local.resource_name_stub_primary}-green" = "shared"
    "k8s.io/cluster-autoscaler/${local.resource_name_stub_primary}-blue"  = "shared"
    "k8s.io/cluster-autoscaler/${local.resource_name_stub_primary}-green" = "shared"
    "k8s.io/cluster-autoscaler/enabled" = "true"
  })

  subnet_pub_tags_primary = merge(local.k8s_tags_primary, local.k8s_tags_subnet_pub)
  subnet_pvt_tags_primary = merge(local.k8s_tags_primary, local.k8s_tags_subnet_pvt)

  vpc_tags_failover = merge(local.k8s_tags_failover, {
    "${local.resource_name_stub_failover}-blue"  = "shared"
    "${local.resource_name_stub_failover}-green" = "shared"
    "k8s.io/cluster-autoscaler/${local.resource_name_stub_failover}-blue"  = "shared"
    "k8s.io/cluster-autoscaler/${local.resource_name_stub_failover}-green" = "shared"
    "k8s.io/cluster-autoscaler/enabled" = "true"
  })

  subnet_pub_tags_failover = merge(local.k8s_tags_failover, local.k8s_tags_subnet_pub)
  subnet_pvt_tags_failover = merge(local.k8s_tags_failover, local.k8s_tags_subnet_pvt)

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

  acm_san_names = concat(
    [
      for zone in var.r53_zones : 
      (var.deployment_environment != "prd" ? "${var.deployment_environment}.${zone}" : zone)
    ],
    [
      for zone in var.r53_zones : 
      (var.deployment_environment != "prd" ? "*.${var.deployment_environment}.${zone}" : "*.${zone}")
    ]
  )
}