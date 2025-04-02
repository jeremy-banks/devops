locals {
  vpc_inbound_cidrsubnets_primary = (
    var.azs_used == 4 ? cidrsubnets(var.vpc_cidr_infrastructure.inbound_primary, 3, 3, 3, 3, 12, 12, 12, 12) :
    var.azs_used == 3 ? cidrsubnets(var.vpc_cidr_infrastructure.inbound_primary, 2, 2, 2, 12, 12, 12) :
    var.azs_used == 2 ? cidrsubnets(var.vpc_cidr_infrastructure.inbound_primary, 2, 2, 12, 12) :
    null
  )

  vpc_inbound_public_subnets_primary = (
    var.azs_used == 4 ? [local.vpc_inbound_cidrsubnets_primary[0], local.vpc_inbound_cidrsubnets_primary[1], local.vpc_inbound_cidrsubnets_primary[2], local.vpc_inbound_cidrsubnets_primary[3]] :
    var.azs_used == 3 ? [local.vpc_inbound_cidrsubnets_primary[0], local.vpc_inbound_cidrsubnets_primary[1], local.vpc_inbound_cidrsubnets_primary[2]] :
    var.azs_used == 2 ? [local.vpc_inbound_cidrsubnets_primary[0], local.vpc_inbound_cidrsubnets_primary[1]] :
    null
  )

  vpc_inbound_intra_subnets_primary = (
    var.azs_used == 4 ? [local.vpc_inbound_cidrsubnets_primary[4], local.vpc_inbound_cidrsubnets_primary[5], local.vpc_inbound_cidrsubnets_primary[6], local.vpc_inbound_cidrsubnets_primary[7]] :
    var.azs_used == 3 ? [local.vpc_inbound_cidrsubnets_primary[3], local.vpc_inbound_cidrsubnets_primary[4], local.vpc_inbound_cidrsubnets_primary[5]] :
    var.azs_used == 2 ? [local.vpc_inbound_cidrsubnets_primary[2], local.vpc_inbound_cidrsubnets_primary[3]] :
    null
  )

  vpc_inbound_tags_primary = {}
}

module "vpc_inbound_primary" {
  source    = "terraform-aws-modules/vpc/aws"
  version   = "5.19.0"
  providers = { aws = aws.network_prd }

  name = "${local.resource_name_stub_primary}-vpc-inbound-primary"
  cidr = var.vpc_cidr_infrastructure.inbound_primary

  azs                 = local.azs_primary
  private_subnets     = []
  public_subnets      = local.vpc_inbound_public_subnets_primary
  database_subnets    = []
  elasticache_subnets = []
  redshift_subnets    = []
  intra_subnets       = local.vpc_inbound_intra_subnets_primary

  public_subnet_names = [for i in range(4) : "${format("%s-pub-", "${local.resource_name_stub_primary}-vpc-inbound-primary")}${i}"]
  intra_subnet_names  = [for i in range(4) : "${format("%s-tgw-", "${local.resource_name_stub_primary}-vpc-inbound-primary")}${i}"]

  create_database_subnet_group    = false
  create_elasticache_subnet_group = false
  create_redshift_subnet_group    = false

  manage_default_network_acl = true

  manage_default_route_table          = true
  create_multiple_intra_route_tables  = true
  create_multiple_public_route_tables = true

  manage_default_security_group  = true
  default_security_group_name    = "NEVER-USE-THIS-SECURITY-GROUP"
  default_security_group_ingress = []
  default_security_group_egress  = []
  default_security_group_tags    = {}

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = false

  # create_igw = false

  enable_dhcp_options              = true
  dhcp_options_domain_name_servers = [replace(var.vpc_cidr_infrastructure.inbound_primary, "0/16", "2")]
  dhcp_options_ntp_servers         = var.ntp_servers

  vpc_tags = local.vpc_inbound_tags_primary
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_inbound_to_tgw_primary" {
  provider = aws.network_prd

  subnet_ids         = module.vpc_inbound_primary.intra_subnets
  transit_gateway_id = aws_ec2_transit_gateway.tgw_primary.id
  vpc_id             = module.vpc_inbound_primary.vpc_id

  appliance_mode_support                          = "disable"
  dns_support                                     = "enable"
  security_group_referencing_support              = "enable"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true

  tags = { Name = "inbound-vpc-attach-tgw-primary" }
}

import {
  provider = aws.network_prd

  for_each = local.azs_primary

  to = aws_route.vpc_inbound_primary_pub_local[each.key]
  id = "${module.vpc_inbound_primary.public_route_table_ids[each.key]}_${var.vpc_cidr_infrastructure.inbound_primary}"
}

resource "aws_route" "vpc_inbound_primary_pub_local" {
  provider = aws.network_prd

  count = length(local.azs_primary)

  route_table_id         = module.vpc_inbound_primary.public_route_table_ids[count.index]
  destination_cidr_block = var.vpc_cidr_infrastructure.inbound_primary
  gateway_id             = "local"
}

resource "aws_route" "vpc_inbound_primary_pub_tgw" {
  provider = aws.network_prd

  count = var.azs_used

  route_table_id         = module.vpc_inbound_primary.public_route_table_ids[count.index]
  destination_cidr_block = var.vpc_cidr_infrastructure.transit_gateway
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_primary.id
}

# import {
#   provider = aws.network_prd

#   for_each =  toset(local.azs_primary)

#   to = aws_route.vpc_inbound_primary_pub_igw[each.key]
#   id = "${module.vpc_inbound_primary.public_route_table_ids[each.key]}_${var.vpc_cidr_infrastructure.inbound_primary}"
# }

# resource "aws_route" "vpc_inbound_primary_pub_igw" {
#   provider = aws.network_prd

#   count = var.azs_used

#   route_table_id         = module.vpc_inbound_primary.public_route_table_ids[count.index]
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = module.vpc_inbound_primary.igw_id
# }

# intra_route_table_ids
# private_route_table_ids
# public_route_table_ids

# resource "aws_route_table" "vpc_inbound_primary_pub" {
#   provider = aws.network_prd

#   vpc_id = module.vpc_inbound_primary.vpc_id

#   #local
#   # route {
#   #   cidr_block = var.vpc_cidr_infrastructure.inbound_primary
#   #   gateway_id = "local"
#   # }

#   #tgw

#   #igw
#   # route {
#   #   cidr_block = "10.0.0.0/8"
#   #   gateway_id = aws_internet_gateway.example.id
#   # }
# }

# resource "aws_route_table_association" "vpc_inbound_primary_pub" {
#   provider = aws.network_prd

#   count = var.azs_used

#   subnet_id      = module.vpc_inbound_primary.public_subnets[count.index]
#   route_table_id = aws_route_table.vpc_inbound_primary_pub.id
# }