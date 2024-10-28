module "vpc_primary" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"
  providers = { aws = aws.sdlc_stg }

  create_vpc = var.vpc_cidr_substitute != ""

  enable_nat_gateway      = true
  reuse_nat_ips           = true
  one_nat_gateway_per_az  = true
  external_nat_ip_ids     = aws_eip.vpc_nat_primary[*].id
  external_nat_ips        = aws_eip.vpc_nat_primary[*].public_ip

  name  = local.vpc_name_primary
  public_subnet_names   = [ "${local.vpc_subnet_pub_name_primary}0", "${local.vpc_subnet_pub_name_primary}1", "${local.vpc_subnet_pub_name_primary}2" ]
  private_subnet_names  = [ "${local.vpc_subnet_pvt_name_primary}0", "${local.vpc_subnet_pvt_name_primary}1", "${local.vpc_subnet_pvt_name_primary}2" ]


  cidr            = local.vpc_cidr_primary
  azs             = local.vpc_azs_primary
  public_subnets  = local.vpc_subnets_public_primary
  private_subnets = local.vpc_subnets_private_primary

  public_subnet_tags  = local.subnet_pub_tags_primary
  private_subnet_tags = local.subnet_pvt_tags_primary
  vpc_tags            = merge({"Name" = "${local.vpc_name_primary}"}, local.vpc_tags_primary)

  manage_default_security_group   = true
  default_security_group_name     = "NEVER-USE-THIS-SECURITY-GROUP"
  default_security_group_ingress  = []
  default_security_group_egress   = []

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_dhcp_options               = true
  dhcp_options_domain_name_servers  = [local.vpc_dns_primary]
  dhcp_options_ntp_servers          = local.vpc_ntp_servers
}

module "vpc_main_sg_primary" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"
  providers = { aws = aws.sdlc_stg }

  create_sg = var.vpc_cidr_substitute != ""

  name        = "${local.resource_name_stub_primary}-main"
  use_name_prefix = false
  description = "main security group for ${local.resource_name_stub_primary}"
  vpc_id      = module.vpc_primary.vpc_id

  ingress_with_self = [
    {
      rule = "all-all"
      description = "allow ingress from self"
    },
  ]

  egress_with_self = [
    {
      rule = "all-all"
      description = "allow egress to self"
    },
  ]
}

module "vpc_failover" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"
  providers = { aws = aws.sdlc_stg_failover }

  create_vpc = var.vpc_cidr_substitute != ""

  enable_nat_gateway      = true
  reuse_nat_ips           = true
  one_nat_gateway_per_az  = true
  external_nat_ip_ids     = aws_eip.vpc_nat_failover[*].id
  external_nat_ips        = aws_eip.vpc_nat_failover[*].public_ip

  name  = local.vpc_name_failover
  public_subnet_names   = [ "${local.vpc_subnet_pub_name_failover}0", "${local.vpc_subnet_pub_name_failover}1", "${local.vpc_subnet_pub_name_failover}2" ]
  private_subnet_names  = [ "${local.vpc_subnet_pvt_name_failover}0", "${local.vpc_subnet_pvt_name_failover}1", "${local.vpc_subnet_pvt_name_failover}2" ]

  cidr            = local.vpc_cidr_failover
  azs             = local.vpc_azs_failover
  public_subnets  = local.vpc_subnets_public_failover
  private_subnets = local.vpc_subnets_private_failover

  public_subnet_tags  = local.subnet_pub_tags_failover
  private_subnet_tags = local.subnet_pvt_tags_failover
  vpc_tags            = merge({"Name" = "${local.vpc_name_failover}"}, local.vpc_tags_primary)

  manage_default_security_group   = true
  default_security_group_name     = "NEVER-USE-THIS-SECURITY-GROUP"
  default_security_group_ingress  = []
  default_security_group_egress   = []

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_dhcp_options               = true
  dhcp_options_domain_name_servers  = [local.vpc_dns_failover]
  dhcp_options_ntp_servers          = local.vpc_ntp_servers
}

module "vpc_main_sg_failover" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"
  providers = { aws = aws.sdlc_stg_failover }

  create_sg = var.vpc_cidr_substitute != ""

  name        = "${local.resource_name_stub_failover}-main"
  use_name_prefix = false
  description = "main security group for ${local.resource_name_stub_failover}"
  vpc_id      = module.vpc_failover.vpc_id

  ingress_with_self = [
    {
      rule = "all-all"
      description = "allow ingress from self"
    },
  ]

  egress_with_self = [
    {
      rule = "all-all"
      description = "allow egress to self"
    },
  ]
}