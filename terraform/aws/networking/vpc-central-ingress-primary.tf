locals {
  vpc_central_ingress_cidrsubnets_primary = (
    var.azs_number_used == 4 ? cidrsubnets(var.vpc_cidr_infrastructure.central_ingress_primary, 3, 3, 3, 3, 12, 12, 12, 12) :
    var.azs_number_used == 3 ? cidrsubnets(var.vpc_cidr_infrastructure.central_ingress_primary, 2, 2, 2, 12, 12, 12) :
    var.azs_number_used == 2 ? cidrsubnets(var.vpc_cidr_infrastructure.central_ingress_primary, 2, 2, 12, 12) :
    null
  )

  vpc_central_ingress_public_subnets_primary = (
    var.azs_number_used == 4 ? [local.vpc_central_ingress_cidrsubnets_primary[0], local.vpc_central_ingress_cidrsubnets_primary[1], local.vpc_central_ingress_cidrsubnets_primary[2], local.vpc_central_ingress_cidrsubnets_primary[3]] :
    var.azs_number_used == 3 ? [local.vpc_central_ingress_cidrsubnets_primary[0], local.vpc_central_ingress_cidrsubnets_primary[1], local.vpc_central_ingress_cidrsubnets_primary[2]] :
    var.azs_number_used == 2 ? [local.vpc_central_ingress_cidrsubnets_primary[0], local.vpc_central_ingress_cidrsubnets_primary[1]] :
    null
  )

  vpc_central_ingress_intra_subnets_primary = (
    var.azs_number_used == 4 ? [local.vpc_central_ingress_cidrsubnets_primary[4], local.vpc_central_ingress_cidrsubnets_primary[5], local.vpc_central_ingress_cidrsubnets_primary[6], local.vpc_central_ingress_cidrsubnets_primary[7]] :
    var.azs_number_used == 3 ? [local.vpc_central_ingress_cidrsubnets_primary[3], local.vpc_central_ingress_cidrsubnets_primary[4], local.vpc_central_ingress_cidrsubnets_primary[5]] :
    var.azs_number_used == 2 ? [local.vpc_central_ingress_cidrsubnets_primary[2], local.vpc_central_ingress_cidrsubnets_primary[3]] :
    null
  )

  vpc_central_ingress_tags_primary = {}
}

module "vpc_central_ingress_primary" {
  source    = "terraform-aws-modules/vpc/aws"
  version   = "6.0.1"
  providers = { aws = aws.networking_prd }

  name = "${local.resource_name_stub_primary}-vpc-central-ingress-primary"
  cidr = var.vpc_cidr_infrastructure.central_ingress_primary

  azs                 = local.azs_primary
  private_subnets     = []
  public_subnets      = local.vpc_central_ingress_public_subnets_primary
  database_subnets    = []
  elasticache_subnets = []
  redshift_subnets    = []
  intra_subnets       = local.vpc_central_ingress_intra_subnets_primary

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

  enable_nat_gateway = false

  enable_dhcp_options              = true
  dhcp_options_domain_name_servers = [replace(var.vpc_cidr_infrastructure.central_ingress_primary, "0/16", "2")]
  dhcp_options_ntp_servers         = var.ntp_servers

  vpc_tags = local.vpc_central_ingress_tags_primary
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_central_ingress_to_tgw_primary" {
  provider = aws.networking_prd

  subnet_ids         = module.vpc_central_ingress_primary.intra_subnets
  transit_gateway_id = aws_ec2_transit_gateway.tgw_primary.id
  vpc_id             = module.vpc_central_ingress_primary.vpc_id

  appliance_mode_support             = "disable"
  dns_support                        = "enable"
  security_group_referencing_support = "enable"

  # transit_gateway_default_route_table_association = false
  # transit_gateway_default_route_table_propagation = false

  tags = { Name = "${local.resource_name_stub_primary}-${var.this_slug}-tgw-attach-central-ingress-vpc" }
}

resource "aws_route" "central_ingress_pub_to_tgw_primary" {
  provider = aws.networking_prd

  count = length(module.vpc_central_ingress_primary.public_route_table_ids)

  route_table_id         = module.vpc_central_ingress_primary.public_route_table_ids[count.index]
  destination_cidr_block = var.vpc_cidr_infrastructure.transit_gateway
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_primary.id
}

resource "aws_route" "central_ingress_intra_to_tgw_primary" {
  provider = aws.networking_prd

  count = length(module.vpc_central_ingress_primary.intra_route_table_ids)

  route_table_id         = module.vpc_central_ingress_primary.intra_route_table_ids[count.index]
  destination_cidr_block = var.vpc_cidr_infrastructure.transit_gateway
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_primary.id
}