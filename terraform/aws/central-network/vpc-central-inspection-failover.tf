locals {
  vpc_inspection_cidrsubnets_failover = (
    var.vpc_azs_number_used_network == 4 ? cidrsubnets(var.vpc_cidr.central_inspection_failover, 3, 3, 3, 3, 12, 12, 12, 12) :
    var.vpc_azs_number_used_network == 3 ? cidrsubnets(var.vpc_cidr.central_inspection_failover, 2, 2, 2, 12, 12, 12) :
    var.vpc_azs_number_used_network == 2 ? cidrsubnets(var.vpc_cidr.central_inspection_failover, 2, 2, 12, 12) :
    null
  )

  vpc_inspection_private_subnets_failover = (
    var.vpc_azs_number_used_network == 4 ? [local.vpc_inspection_cidrsubnets_failover[0], local.vpc_inspection_cidrsubnets_failover[1], local.vpc_inspection_cidrsubnets_failover[2], local.vpc_inspection_cidrsubnets_failover[3]] :
    var.vpc_azs_number_used_network == 3 ? [local.vpc_inspection_cidrsubnets_failover[0], local.vpc_inspection_cidrsubnets_failover[1], local.vpc_inspection_cidrsubnets_failover[2]] :
    var.vpc_azs_number_used_network == 2 ? [local.vpc_inspection_cidrsubnets_failover[0], local.vpc_inspection_cidrsubnets_failover[1]] :
    null
  )

  vpc_inspection_intra_subnets_failover = (
    var.vpc_azs_number_used_network == 4 ? [local.vpc_inspection_cidrsubnets_failover[4], local.vpc_inspection_cidrsubnets_failover[5], local.vpc_inspection_cidrsubnets_failover[6], local.vpc_inspection_cidrsubnets_failover[7]] :
    var.vpc_azs_number_used_network == 3 ? [local.vpc_inspection_cidrsubnets_failover[3], local.vpc_inspection_cidrsubnets_failover[4], local.vpc_inspection_cidrsubnets_failover[5]] :
    var.vpc_azs_number_used_network == 2 ? [local.vpc_inspection_cidrsubnets_failover[2], local.vpc_inspection_cidrsubnets_failover[3]] :
    null
  )

  vpc_inspection_tags_failover = {}
}

module "vpc_inspection_failover" {
  source    = "terraform-aws-modules/vpc/aws"
  version   = "~> 6.0.1"
  providers = { aws = aws.network_prd_failover }

  count = var.create_failover_region_network ? 1 : 0

  name = "${local.resource_name_failover}-vpc-central-inspection"
  cidr = var.vpc_cidr.central_inspection_failover

  azs                 = slice(local.vpc_az_ids_failover, 0, var.vpc_azs_number_used_network)
  private_subnets     = local.vpc_inspection_private_subnets_failover
  public_subnets      = []
  database_subnets    = []
  elasticache_subnets = []
  redshift_subnets    = []
  intra_subnets       = local.vpc_inspection_intra_subnets_failover

  private_subnet_suffix = "pvt"
  intra_subnet_suffix   = "tgw"

  create_database_subnet_group    = false
  create_elasticache_subnet_group = false
  create_redshift_subnet_group    = false

  manage_default_network_acl = true

  manage_default_route_table = true
  default_route_table_name   = "DO-NOT-USE"
  default_route_table_routes = []

  create_igw = false

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
  dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]
  dhcp_options_ntp_servers         = var.ntp_servers

  vpc_tags = local.vpc_inspection_tags_failover
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_inspection_to_tgw_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region_network ? 1 : 0

  subnet_ids         = module.vpc_inspection_failover[0].intra_subnets
  transit_gateway_id = aws_ec2_transit_gateway.tgw_failover[0].id
  vpc_id             = module.vpc_inspection_failover[0].vpc_id

  appliance_mode_support             = "enable"
  dns_support                        = "enable"
  security_group_referencing_support = "enable"

  # transit_gateway_default_route_table_association = false
  # transit_gateway_default_route_table_propagation = false

  tags = { Name = "vpc-central-inspection-tgw-attach-failover" }
}