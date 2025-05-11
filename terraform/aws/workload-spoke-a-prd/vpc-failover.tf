locals {
  vpc_workload_spoke_a_cidrsubnets_failover = (
    var.azs_used == 4 ? cidrsubnets(var.vpc_cidr_infrastructure.workload_spoke_a_prd_failover, 3, 3, 3, 3, 12, 12, 12, 12) :
    var.azs_used == 3 ? cidrsubnets(var.vpc_cidr_infrastructure.workload_spoke_a_prd_failover, 2, 2, 2, 12, 12, 12) :
    var.azs_used == 2 ? cidrsubnets(var.vpc_cidr_infrastructure.workload_spoke_a_prd_failover, 2, 2, 12, 12) :
    null
  )

  vpc_workload_spoke_a_private_subnets_failover = (
    var.azs_used == 4 ? [local.vpc_workload_spoke_a_cidrsubnets_failover[0], local.vpc_workload_spoke_a_cidrsubnets_failover[1], local.vpc_workload_spoke_a_cidrsubnets_failover[2], local.vpc_workload_spoke_a_cidrsubnets_failover[3]] :
    var.azs_used == 3 ? [local.vpc_workload_spoke_a_cidrsubnets_failover[0], local.vpc_workload_spoke_a_cidrsubnets_failover[1], local.vpc_workload_spoke_a_cidrsubnets_failover[2]] :
    var.azs_used == 2 ? [local.vpc_workload_spoke_a_cidrsubnets_failover[0], local.vpc_workload_spoke_a_cidrsubnets_failover[1]] :
    null
  )

  vpc_workload_spoke_a_intra_subnets_failover = (
    var.azs_used == 4 ? [local.vpc_workload_spoke_a_cidrsubnets_failover[4], local.vpc_workload_spoke_a_cidrsubnets_failover[5], local.vpc_workload_spoke_a_cidrsubnets_failover[6], local.vpc_workload_spoke_a_cidrsubnets_failover[7]] :
    var.azs_used == 3 ? [local.vpc_workload_spoke_a_cidrsubnets_failover[3], local.vpc_workload_spoke_a_cidrsubnets_failover[4], local.vpc_workload_spoke_a_cidrsubnets_failover[5]] :
    var.azs_used == 2 ? [local.vpc_workload_spoke_a_cidrsubnets_failover[2], local.vpc_workload_spoke_a_cidrsubnets_failover[3]] :
    null
  )

  vpc_workload_spoke_a_tags_failover = {}
}

module "vpc_failover" {
  source    = "terraform-aws-modules/vpc/aws"
  version   = "5.21.0"
  providers = { aws = aws.workload_spoke_a_prd_failover }

  count = var.create_failover_region ? 1 : 0

  name = "${local.resource_name_stub_failover}-${var.this_slug}-vpc-failover"
  cidr = var.vpc_cidr_infrastructure.workload_spoke_a_prd_failover

  azs                 = local.azs_failover
  private_subnets     = local.vpc_workload_spoke_a_private_subnets_failover
  public_subnets      = []
  database_subnets    = []
  elasticache_subnets = []
  redshift_subnets    = []
  intra_subnets       = local.vpc_workload_spoke_a_intra_subnets_failover

  private_subnet_suffix = "pvt"
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
  dhcp_options_domain_name_servers = [replace(var.vpc_cidr_infrastructure.workload_spoke_a_prd_failover, "0/16", "2")]
  dhcp_options_ntp_servers         = var.ntp_servers

  vpc_tags = local.vpc_workload_spoke_a_tags_failover
}

module "sg_main_failover" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.3.0"
  providers = { aws = aws.workload_spoke_a_prd_failover }

  count = var.create_failover_region ? 1 : 0

  name        = "${local.resource_name_stub_failover}-${var.this_slug}-main-sg"
  description = "${local.resource_name_stub_failover}-${var.this_slug}-main-sg"
  vpc_id      = module.vpc_failover[0].vpc_id

  ingress_with_self = [{ rule = "all-all" }]
  egress_with_self  = [{ rule = "all-all" }]

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = { Name = "${local.resource_name_stub_primary}-${var.this_slug}-main-sg" }
}

resource "aws_route" "private_to_tgw_failover" {
  provider = aws.workload_spoke_a_prd_failover

  count = var.create_failover_region ? length(module.vpc_failover[0].private_route_table_ids) : 0

  route_table_id         = module.vpc_failover[0].private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw_failover[0].id
}

resource "aws_route" "intra_to_tgw_failover" {
  provider = aws.workload_spoke_a_prd_failover

  count = var.create_failover_region ? length(module.vpc_failover[0].intra_route_table_ids) : 0

  route_table_id         = module.vpc_failover[0].intra_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw_failover[0].id
}

data "aws_ec2_transit_gateway" "tgw_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  filter {
    name   = "options.amazon-side-asn"
    values = [var.tgw_asn.failover]
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_workload_spoke_a_to_tgw_failover" {
  provider = aws.workload_spoke_a_prd_failover

  count = var.create_failover_region ? 1 : 0

  subnet_ids         = module.vpc_failover[0].intra_subnets
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw_failover[0].id
  vpc_id             = module.vpc_failover[0].vpc_id

  appliance_mode_support             = "disable"
  dns_support                        = "enable"
  security_group_referencing_support = "enable"

  # transit_gateway_default_route_table_association = false
  # transit_gateway_default_route_table_propagation = false

  tags = { Name = "${local.resource_name_stub_failover}-${var.this_slug}-tgw-attach" }
}

resource "aws_ec2_transit_gateway_route_table_association" "vpc_workload_spoke_a_to_tgw_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_workload_spoke_a_to_tgw_failover[0].id
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.tgw_pre_inspection_failover[0].id
}

data "aws_ec2_transit_gateway_vpc_attachment" "tgw_post_inspection_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  filter {
    name   = "tag:Name"
    values = ["${local.resource_name_stub_failover}-network-tgw-attach-inspection-vpc"]
  }
}

data "aws_ec2_transit_gateway_route_table" "tgw_pre_inspection_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  filter {
    name   = "tag:Name"
    values = ["${local.resource_name_stub_failover}-network-tgw-pre-inspection"]
  }
}

data "aws_ec2_transit_gateway_route_table" "tgw_post_inspection_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  filter {
    name   = "tag:Name"
    values = ["${local.resource_name_stub_failover}-network-tgw-post-inspection"]
  }
}

data "aws_ec2_transit_gateway_peering_attachment" "tgw_peer_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  filter {
    name   = "tag:Name"
    values = ["${local.resource_name_stub_failover}-network-tgw-peer-requester"]
  }
}

resource "aws_ec2_transit_gateway_route" "post_inspection_workload_spoke_a_failover_to_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  destination_cidr_block         = var.vpc_cidr_infrastructure.workload_spoke_a_prd_failover
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_workload_spoke_a_to_tgw_failover[0].id
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.tgw_post_inspection_failover[0].id
}

resource "aws_ec2_transit_gateway_route" "post_inspection_workload_spoke_a_failover_to_primary" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  destination_cidr_block         = var.vpc_cidr_infrastructure.workload_spoke_a_prd_primary
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_peering_attachment.tgw_peer_primary[0].id
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.tgw_post_inspection_failover[0].id
}