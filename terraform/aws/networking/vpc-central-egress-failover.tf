locals {
  vpc_central_egress_cidrsubnets_failover = (
    var.azs_number_used == 4 ? cidrsubnets(var.vpc_cidr_infrastructure.central_egress_failover, 3, 3, 3, 3, 12, 12, 12, 12) :
    var.azs_number_used == 3 ? cidrsubnets(var.vpc_cidr_infrastructure.central_egress_failover, 2, 2, 2, 12, 12, 12) :
    var.azs_number_used == 2 ? cidrsubnets(var.vpc_cidr_infrastructure.central_egress_failover, 2, 2, 12, 12) :
    null
  )

  vpc_central_egress_public_subnets_failover = (
    var.azs_number_used == 4 ? [local.vpc_central_egress_cidrsubnets_failover[0], local.vpc_central_egress_cidrsubnets_failover[1], local.vpc_central_egress_cidrsubnets_failover[2], local.vpc_central_egress_cidrsubnets_failover[3]] :
    var.azs_number_used == 3 ? [local.vpc_central_egress_cidrsubnets_failover[0], local.vpc_central_egress_cidrsubnets_failover[1], local.vpc_central_egress_cidrsubnets_failover[2]] :
    var.azs_number_used == 2 ? [local.vpc_central_egress_cidrsubnets_failover[0], local.vpc_central_egress_cidrsubnets_failover[1]] :
    null
  )

  vpc_central_egress_intra_subnets_failover = (
    var.azs_number_used == 4 ? [local.vpc_central_egress_cidrsubnets_failover[4], local.vpc_central_egress_cidrsubnets_failover[5], local.vpc_central_egress_cidrsubnets_failover[6], local.vpc_central_egress_cidrsubnets_failover[7]] :
    var.azs_number_used == 3 ? [local.vpc_central_egress_cidrsubnets_failover[3], local.vpc_central_egress_cidrsubnets_failover[4], local.vpc_central_egress_cidrsubnets_failover[5]] :
    var.azs_number_used == 2 ? [local.vpc_central_egress_cidrsubnets_failover[2], local.vpc_central_egress_cidrsubnets_failover[3]] :
    null
  )

  vpc_central_egress_tags_failover = {}
}

module "vpc_central_egress_failover" {
  source    = "terraform-aws-modules/vpc/aws"
  version   = "6.0.1"
  providers = { aws = aws.networking_prd_failover }

  count = var.create_failover_region ? 1 : 0

  name = "${local.resource_name_stub_failover}-vpc-central-egress-failover"
  cidr = var.vpc_cidr_infrastructure.central_egress_failover

  azs                 = local.azs_failover
  private_subnets     = []
  public_subnets      = local.vpc_central_egress_public_subnets_failover
  database_subnets    = []
  elasticache_subnets = []
  redshift_subnets    = []
  intra_subnets       = local.vpc_central_egress_intra_subnets_failover

  public_subnet_suffix = "pub"
  intra_subnet_suffix  = "tgw"

  create_database_subnet_group    = false
  create_elasticache_subnet_group = false
  create_redshift_subnet_group    = false

  manage_default_network_acl = true

  manage_default_route_table = true
  default_route_table_name   = "DO-NOT-USE"
  default_route_table_routes = []

  create_multiple_intra_route_tables  = true
  create_multiple_public_route_tables = true

  manage_default_security_group  = true
  default_security_group_name    = "DO-NOT-USE"
  default_security_group_ingress = []
  default_security_group_egress  = []
  default_security_group_tags    = {}

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway               = true
  one_nat_gateway_per_az           = true
  reuse_nat_ips                    = true
  external_nat_ip_ids              = aws_eip.vpc_central_egress_failover_nat[*].id
  external_nat_ips                 = aws_eip.vpc_central_egress_failover_nat[*].public_ip
  create_private_nat_gateway_route = false

  enable_dhcp_options              = true
  dhcp_options_domain_name_servers = [replace(var.vpc_cidr_infrastructure.central_egress_failover, "0/16", "2")]
  dhcp_options_ntp_servers         = var.ntp_servers

  vpc_tags = local.vpc_central_egress_tags_failover
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_central_egress_to_tgw_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  subnet_ids         = module.vpc_central_egress_failover[0].intra_subnets
  transit_gateway_id = aws_ec2_transit_gateway.tgw_failover[0].id
  vpc_id             = module.vpc_central_egress_failover[0].vpc_id

  appliance_mode_support             = "disable"
  dns_support                        = "enable"
  security_group_referencing_support = "enable"

  # transit_gateway_default_route_table_association = false
  # transit_gateway_default_route_table_propagation = false

  tags = { Name = "${local.resource_name_stub_failover}-${var.this_slug}-tgw-attach-central-egress-vpc" }
}

resource "aws_route" "central_egress_pub_to_tgw_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? length(module.vpc_central_egress_failover[0].public_route_table_ids) : 0

  route_table_id         = module.vpc_central_egress_failover[0].public_route_table_ids[count.index]
  destination_cidr_block = var.vpc_cidr_infrastructure.transit_gateway
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_failover[0].id
}

resource "aws_route" "central_egress_intra_to_tgw_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? length(module.vpc_central_egress_failover[0].intra_route_table_ids) : 0

  route_table_id         = module.vpc_central_egress_failover[0].intra_route_table_ids[count.index]
  destination_cidr_block = var.vpc_cidr_infrastructure.transit_gateway
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_failover[0].id
}

resource "aws_route" "central_egress_intra_to_nat_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? length(module.vpc_central_egress_failover[0].intra_route_table_ids) : 0

  route_table_id         = module.vpc_central_egress_failover[0].intra_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = module.vpc_central_egress_failover[0].natgw_ids[count.index]
}