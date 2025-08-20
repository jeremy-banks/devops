locals {
  # vpc_cidr_primary = var.vpc_cidr_primary

  vpc_cidrsubnets_primary = (
    var.azs_number_used == 4 ? cidrsubnets(local.vpc_cidr_primary, 3, 3, 3, 3, 4, 4, 4, 4, 12, 12, 12, 12) :
    var.azs_number_used == 3 ? cidrsubnets(local.vpc_cidr_primary, 2, 2, 2, 4, 4, 4, 12, 12, 12) :
    var.azs_number_used == 2 ? cidrsubnets(local.vpc_cidr_primary, 2, 2, 3, 3, 12, 12) :
    null
  )

  vpc_private_subnets_primary = (
    var.azs_number_used == 4 ? [local.vpc_cidrsubnets_primary[0], local.vpc_cidrsubnets_primary[1], local.vpc_cidrsubnets_primary[2], local.vpc_cidrsubnets_primary[3]] :
    var.azs_number_used == 3 ? [local.vpc_cidrsubnets_primary[0], local.vpc_cidrsubnets_primary[1], local.vpc_cidrsubnets_primary[2]] :
    var.azs_number_used == 2 ? [local.vpc_cidrsubnets_primary[0], local.vpc_cidrsubnets_primary[1]] :
    null
  )

  vpc_public_subnets_primary = (
    var.azs_number_used == 4 ? [local.vpc_cidrsubnets_primary[4], local.vpc_cidrsubnets_primary[5], local.vpc_cidrsubnets_primary[6], local.vpc_cidrsubnets_primary[7]] :
    var.azs_number_used == 3 ? [local.vpc_cidrsubnets_primary[3], local.vpc_cidrsubnets_primary[4], local.vpc_cidrsubnets_primary[5]] :
    var.azs_number_used == 2 ? [local.vpc_cidrsubnets_primary[2], local.vpc_cidrsubnets_primary[3]] :
    null
  )

  vpc_intra_subnets_primary = (
    var.azs_number_used == 4 ? [local.vpc_cidrsubnets_primary[8], local.vpc_cidrsubnets_primary[9], local.vpc_cidrsubnets_primary[10], local.vpc_cidrsubnets_primary[11]] :
    var.azs_number_used == 3 ? [local.vpc_cidrsubnets_primary[6], local.vpc_cidrsubnets_primary[7], local.vpc_cidrsubnets_primary[8]] :
    var.azs_number_used == 2 ? [local.vpc_cidrsubnets_primary[4], local.vpc_cidrsubnets_primary[5]] :
    null
  )

  vpc_workload_product_a_tags_primary = {}
}

module "vpc_primary" {
  source    = "terraform-aws-modules/vpc/aws"
  version   = "6.0.1"
  providers = { aws = aws.this }

  name = "${local.resource_name_primary}-vpc"
  cidr = local.vpc_cidr_primary

  azs                 = slice(var.azs_primary, 0, var.azs_number_used)
  private_subnets     = local.vpc_private_subnets_primary
  public_subnets      = var.create_vpc_public_subnets ? local.vpc_public_subnets_primary : []
  database_subnets    = []
  elasticache_subnets = []
  redshift_subnets    = []
  intra_subnets       = local.vpc_intra_subnets_primary

  private_subnet_suffix = "pvt"
  public_subnet_suffix  = "pub"
  intra_subnet_suffix   = "tgw"

  private_subnet_tags = {
    "kubernetes.io/role/alb-ingress"  = 1
    "kubernetes.io/role/internal-elb" = 1
    "kubernetes.io/cluster/blue"      = "shared"
    "kubernetes.io/cluster/green"     = "shared"
  }
  public_subnet_tags = {
    "kubernetes.io/role/alb-ingress" = 1
    "kubernetes.io/role/elb"         = 1
    "kubernetes.io/cluster/blue"     = "shared"
    "kubernetes.io/cluster/green"    = "shared"
  }

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
  dhcp_options_domain_name_servers = [replace(local.vpc_cidr_primary, "0/16", "2")]
  dhcp_options_ntp_servers         = var.ntp_servers

  vpc_tags = merge(
    local.vpc_workload_product_a_tags_primary,
    {
      "kubernetes.io/cluster/blue"        = "owned"
      "kubernetes.io/cluster/green"       = "owned"
      "k8s.io/cluster-autoscaler/enabled" = true
    }
  )
}