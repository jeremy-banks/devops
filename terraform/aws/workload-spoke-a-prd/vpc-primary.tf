locals {
  vpc_workload_spoke_a_cidrsubnets_primary = (
    var.azs_number_used == 4 ? cidrsubnets(var.vpc_cidr_infrastructure.workload_spoke_a_prd_primary, 3, 3, 3, 3, 4, 4, 4, 4, 12, 12, 12, 12) :
    var.azs_number_used == 3 ? cidrsubnets(var.vpc_cidr_infrastructure.workload_spoke_a_prd_primary, 2, 2, 2, 4, 4, 4, 12, 12, 12) :
    var.azs_number_used == 2 ? cidrsubnets(var.vpc_cidr_infrastructure.workload_spoke_a_prd_primary, 2, 2, 3, 3, 12, 12) :
    null
  )

  vpc_workload_spoke_a_private_subnets_primary = (
    var.azs_number_used == 4 ? [local.vpc_workload_spoke_a_cidrsubnets_primary[0], local.vpc_workload_spoke_a_cidrsubnets_primary[1], local.vpc_workload_spoke_a_cidrsubnets_primary[2], local.vpc_workload_spoke_a_cidrsubnets_primary[3]] :
    var.azs_number_used == 3 ? [local.vpc_workload_spoke_a_cidrsubnets_primary[0], local.vpc_workload_spoke_a_cidrsubnets_primary[1], local.vpc_workload_spoke_a_cidrsubnets_primary[2]] :
    var.azs_number_used == 2 ? [local.vpc_workload_spoke_a_cidrsubnets_primary[0], local.vpc_workload_spoke_a_cidrsubnets_primary[1]] :
    null
  )

  vpc_workload_spoke_a_public_subnets_primary = (
    var.azs_number_used == 4 ? [local.vpc_workload_spoke_a_cidrsubnets_primary[4], local.vpc_workload_spoke_a_cidrsubnets_primary[5], local.vpc_workload_spoke_a_cidrsubnets_primary[6], local.vpc_workload_spoke_a_cidrsubnets_primary[7]] :
    var.azs_number_used == 3 ? [local.vpc_workload_spoke_a_cidrsubnets_primary[3], local.vpc_workload_spoke_a_cidrsubnets_primary[4], local.vpc_workload_spoke_a_cidrsubnets_primary[5]] :
    var.azs_number_used == 2 ? [local.vpc_workload_spoke_a_cidrsubnets_primary[2], local.vpc_workload_spoke_a_cidrsubnets_primary[3]] :
    null
  )

  vpc_workload_spoke_a_intra_subnets_primary = (
    var.azs_number_used == 4 ? [local.vpc_workload_spoke_a_cidrsubnets_primary[8], local.vpc_workload_spoke_a_cidrsubnets_primary[9], local.vpc_workload_spoke_a_cidrsubnets_primary[10], local.vpc_workload_spoke_a_cidrsubnets_primary[11]] :
    var.azs_number_used == 3 ? [local.vpc_workload_spoke_a_cidrsubnets_primary[6], local.vpc_workload_spoke_a_cidrsubnets_primary[7], local.vpc_workload_spoke_a_cidrsubnets_primary[8]] :
    var.azs_number_used == 2 ? [local.vpc_workload_spoke_a_cidrsubnets_primary[4], local.vpc_workload_spoke_a_cidrsubnets_primary[5]] :
    null
  )

  vpc_workload_spoke_a_tags_primary = {}
}

module "vpc_primary" {
  source    = "terraform-aws-modules/vpc/aws"
  version   = "6.0.1"
  providers = { aws = aws.workload_spoke_a_prd }

  name = "${local.resource_name_stub_primary}-${var.this_slug}-vpc-primary"
  cidr = var.vpc_cidr_infrastructure.workload_spoke_a_prd_primary

  azs             = slice(var.azs_failover, 0, var.azs_number_used)
  private_subnets = local.vpc_workload_spoke_a_private_subnets_primary
  public_subnets  = (contains(["stg", "prd"], var.deployment_environment) || var.workload_create_vpc_public_subnets) ? local.vpc_workload_spoke_a_public_subnets_primary : []
  #  public_subnets      = local.vpc_workload_spoke_a_public_subnets_primary
  database_subnets    = []
  elasticache_subnets = []
  redshift_subnets    = []
  intra_subnets       = local.vpc_workload_spoke_a_intra_subnets_primary

  private_subnet_suffix = "pvt"
  public_subnet_suffix  = "pub"
  intra_subnet_suffix   = "tgw"

  create_database_subnet_group    = false
  create_elasticache_subnet_group = false
  create_redshift_subnet_group    = false

  manage_default_network_acl = true

  manage_default_route_table = true
  default_route_table_name   = "DO-NOT-USE"
  default_route_table_routes = []

  create_multiple_intra_route_tables = true

  manage_default_security_group  = true
  default_security_group_name    = "DO-NOT-USE"
  default_security_group_ingress = []
  default_security_group_egress  = []
  default_security_group_tags    = {}

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = false

  enable_dhcp_options              = true
  dhcp_options_domain_name_servers = [replace(var.vpc_cidr_infrastructure.workload_spoke_a_prd_primary, "0/16", "2")]
  dhcp_options_ntp_servers         = var.ntp_servers

  vpc_tags = local.vpc_workload_spoke_a_tags_primary
}