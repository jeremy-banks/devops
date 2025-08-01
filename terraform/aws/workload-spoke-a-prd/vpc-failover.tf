locals {
  vpc_workload_spoke_a_cidrsubnets_failover = (
    var.azs_number_used == 4 ? cidrsubnets(var.vpc_cidr_infrastructure.workload_spoke_a_prd_failover, 3, 3, 3, 3, 4, 4, 4, 4, 12, 12, 12, 12) :
    var.azs_number_used == 3 ? cidrsubnets(var.vpc_cidr_infrastructure.workload_spoke_a_prd_failover, 2, 2, 2, 4, 4, 4, 12, 12, 12) :
    var.azs_number_used == 2 ? cidrsubnets(var.vpc_cidr_infrastructure.workload_spoke_a_prd_failover, 2, 2, 3, 3, 12, 12) :
    null
  )

  vpc_workload_spoke_a_private_subnets_failover = (
    var.azs_number_used == 4 ? [local.vpc_workload_spoke_a_cidrsubnets_failover[0], local.vpc_workload_spoke_a_cidrsubnets_failover[1], local.vpc_workload_spoke_a_cidrsubnets_failover[2], local.vpc_workload_spoke_a_cidrsubnets_failover[3]] :
    var.azs_number_used == 3 ? [local.vpc_workload_spoke_a_cidrsubnets_failover[0], local.vpc_workload_spoke_a_cidrsubnets_failover[1], local.vpc_workload_spoke_a_cidrsubnets_failover[2]] :
    var.azs_number_used == 2 ? [local.vpc_workload_spoke_a_cidrsubnets_failover[0], local.vpc_workload_spoke_a_cidrsubnets_failover[1]] :
    null
  )

  vpc_workload_spoke_a_public_subnets_failover = (
    var.azs_number_used == 4 ? [local.vpc_workload_spoke_a_cidrsubnets_failover[4], local.vpc_workload_spoke_a_cidrsubnets_failover[5], local.vpc_workload_spoke_a_cidrsubnets_failover[6], local.vpc_workload_spoke_a_cidrsubnets_failover[7]] :
    var.azs_number_used == 3 ? [local.vpc_workload_spoke_a_cidrsubnets_failover[3], local.vpc_workload_spoke_a_cidrsubnets_failover[4], local.vpc_workload_spoke_a_cidrsubnets_failover[5]] :
    var.azs_number_used == 2 ? [local.vpc_workload_spoke_a_cidrsubnets_failover[2], local.vpc_workload_spoke_a_cidrsubnets_failover[3]] :
    null
  )

  vpc_workload_spoke_a_intra_subnets_failover = (
    var.azs_number_used == 4 ? [local.vpc_workload_spoke_a_cidrsubnets_failover[8], local.vpc_workload_spoke_a_cidrsubnets_failover[9], local.vpc_workload_spoke_a_cidrsubnets_failover[10], local.vpc_workload_spoke_a_cidrsubnets_failover[11]] :
    var.azs_number_used == 3 ? [local.vpc_workload_spoke_a_cidrsubnets_failover[6], local.vpc_workload_spoke_a_cidrsubnets_failover[7], local.vpc_workload_spoke_a_cidrsubnets_failover[8]] :
    var.azs_number_used == 2 ? [local.vpc_workload_spoke_a_cidrsubnets_failover[4], local.vpc_workload_spoke_a_cidrsubnets_failover[5]] :
    null
  )

  vpc_workload_spoke_a_tags_failover = {}
}

module "vpc_failover" {
  source    = "terraform-aws-modules/vpc/aws"
  version   = "6.0.1"
  providers = { aws = aws.workload_spoke_a_prd_failover }

  count = var.create_failover_region ? 1 : 0

  name = "${local.resource_name_stub_failover}-${var.this_slug}-vpc-failover"
  cidr = var.vpc_cidr_infrastructure.workload_spoke_a_prd_failover

  azs                 = slice(var.azs_failover, 0, var.azs_number_used)
  private_subnets     = local.vpc_workload_spoke_a_private_subnets_failover
  public_subnets      = var.create_vpc_public_subnets ? local.vpc_workload_spoke_a_public_subnets_failover : []
  database_subnets    = []
  elasticache_subnets = []
  redshift_subnets    = []
  intra_subnets       = local.vpc_workload_spoke_a_intra_subnets_failover

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
  dhcp_options_domain_name_servers = [replace(var.vpc_cidr_infrastructure.workload_spoke_a_prd_failover, "0/16", "2")]
  dhcp_options_ntp_servers         = var.ntp_servers

  vpc_tags = merge(
    local.vpc_workload_spoke_a_tags_failover,
    {
      "kubernetes.io/cluster/blue"        = "owned"
      "kubernetes.io/cluster/green"       = "owned"
      "k8s.io/cluster-autoscaler/enabled" = true
    }
  )
}