locals {
  vpc_cidrsubnets_failover = (
    var.vpc_azs_number_used == 4 ? cidrsubnets(local.vpc_cidr_failover, 3, 3, 3, 3, 4, 4, 4, 4, 12, 12, 12, 12) :
    var.vpc_azs_number_used == 3 ? cidrsubnets(local.vpc_cidr_failover, 2, 2, 2, 4, 4, 4, 12, 12, 12) :
    var.vpc_azs_number_used == 2 ? cidrsubnets(local.vpc_cidr_failover, 2, 2, 3, 3, 12, 12) :
    null
  )

  vpc_private_subnets_failover = (
    var.vpc_azs_number_used == 4 ? [local.vpc_cidrsubnets_failover[0], local.vpc_cidrsubnets_failover[1], local.vpc_cidrsubnets_failover[2], local.vpc_cidrsubnets_failover[3]] :
    var.vpc_azs_number_used == 3 ? [local.vpc_cidrsubnets_failover[0], local.vpc_cidrsubnets_failover[1], local.vpc_cidrsubnets_failover[2]] :
    var.vpc_azs_number_used == 2 ? [local.vpc_cidrsubnets_failover[0], local.vpc_cidrsubnets_failover[1]] :
    null
  )

  vpc_public_subnets_failover = (
    var.vpc_azs_number_used == 4 ? [local.vpc_cidrsubnets_failover[4], local.vpc_cidrsubnets_failover[5], local.vpc_cidrsubnets_failover[6], local.vpc_cidrsubnets_failover[7]] :
    var.vpc_azs_number_used == 3 ? [local.vpc_cidrsubnets_failover[3], local.vpc_cidrsubnets_failover[4], local.vpc_cidrsubnets_failover[5]] :
    var.vpc_azs_number_used == 2 ? [local.vpc_cidrsubnets_failover[2], local.vpc_cidrsubnets_failover[3]] :
    null
  )

  vpc_intra_subnets_failover = (
    var.vpc_azs_number_used == 4 ? [local.vpc_cidrsubnets_failover[8], local.vpc_cidrsubnets_failover[9], local.vpc_cidrsubnets_failover[10], local.vpc_cidrsubnets_failover[11]] :
    var.vpc_azs_number_used == 3 ? [local.vpc_cidrsubnets_failover[6], local.vpc_cidrsubnets_failover[7], local.vpc_cidrsubnets_failover[8]] :
    var.vpc_azs_number_used == 2 ? [local.vpc_cidrsubnets_failover[4], local.vpc_cidrsubnets_failover[5]] :
    null
  )
}

module "vpc_failover" {
  source    = "terraform-aws-modules/vpc/aws"
  version   = "6.0.1"
  providers = { aws = aws.this_failover }

  count = var.create_failover_region ? 1 : 0

  name = "${local.resource_name.failover}-vpc"
  cidr = local.vpc_cidr_failover

  azs             = slice(local.vpc_az_ids_failover, 0, var.vpc_azs_number_used)
  private_subnets = local.vpc_private_subnets_failover
  public_subnets  = var.create_vpc_public_subnets ? local.vpc_public_subnets_failover : []
  intra_subnets   = local.vpc_intra_subnets_failover

  private_subnet_suffix = "pvt"
  public_subnet_suffix  = "pub"
  intra_subnet_suffix   = "tgw"

  private_subnet_tags = var.private_subnet_tags
  public_subnet_tags  = var.public_subnet_tags

  create_database_subnet_group    = false
  create_elasticache_subnet_group = false
  create_redshift_subnet_group    = false

  default_route_table_name   = "DO-NOT-USE"
  default_route_table_routes = []

  create_multiple_intra_route_tables = true

  default_security_group_name    = "DO-NOT-USE"
  default_security_group_ingress = []
  default_security_group_egress  = []
  default_security_group_tags    = {}

  enable_dhcp_options              = true
  dhcp_options_domain_name_servers = var.dns_servers
  dhcp_options_ntp_servers         = var.ntp_servers

  vpc_tags = var.vpc_tags
}