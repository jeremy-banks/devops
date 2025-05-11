locals {
  vpc_inspection_cidrsubnets_failover = (
    var.azs_used == 4 ? cidrsubnets(var.vpc_cidr_infrastructure.inspection_failover, 3, 3, 3, 3, 12, 12, 12, 12) :
    var.azs_used == 3 ? cidrsubnets(var.vpc_cidr_infrastructure.inspection_failover, 2, 2, 2, 12, 12, 12) :
    var.azs_used == 2 ? cidrsubnets(var.vpc_cidr_infrastructure.inspection_failover, 2, 2, 12, 12) :
    null
  )

  vpc_inspection_private_subnets_failover = (
    var.azs_used == 4 ? [local.vpc_inspection_cidrsubnets_failover[0], local.vpc_inspection_cidrsubnets_failover[1], local.vpc_inspection_cidrsubnets_failover[2], local.vpc_inspection_cidrsubnets_failover[3]] :
    var.azs_used == 3 ? [local.vpc_inspection_cidrsubnets_failover[0], local.vpc_inspection_cidrsubnets_failover[1], local.vpc_inspection_cidrsubnets_failover[2]] :
    var.azs_used == 2 ? [local.vpc_inspection_cidrsubnets_failover[0], local.vpc_inspection_cidrsubnets_failover[1]] :
    null
  )

  vpc_inspection_intra_subnets_failover = (
    var.azs_used == 4 ? [local.vpc_inspection_cidrsubnets_failover[4], local.vpc_inspection_cidrsubnets_failover[5], local.vpc_inspection_cidrsubnets_failover[6], local.vpc_inspection_cidrsubnets_failover[7]] :
    var.azs_used == 3 ? [local.vpc_inspection_cidrsubnets_failover[3], local.vpc_inspection_cidrsubnets_failover[4], local.vpc_inspection_cidrsubnets_failover[5]] :
    var.azs_used == 2 ? [local.vpc_inspection_cidrsubnets_failover[2], local.vpc_inspection_cidrsubnets_failover[3]] :
    null
  )

  vpc_inspection_tags_failover = {}
}

module "vpc_inspection_failover" {
  source    = "terraform-aws-modules/vpc/aws"
  version   = "5.21.0"
  providers = { aws = aws.networking_prd_failover }

  count = var.create_failover_region ? 1 : 0

  name = "${local.resource_name_stub_failover}-vpc-inspection-failover"
  cidr = var.vpc_cidr_infrastructure.inspection_failover

  azs                 = local.azs_failover
  private_subnets     = local.vpc_inspection_private_subnets_failover
  public_subnets      = []
  database_subnets    = []
  elasticache_subnets = []
  redshift_subnets    = []
  intra_subnets       = local.vpc_inspection_intra_subnets_failover

  private_subnet_suffix = "firewall"
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
  dhcp_options_domain_name_servers = [replace(var.vpc_cidr_infrastructure.inspection_failover, "0/16", "2")]
  dhcp_options_ntp_servers         = var.ntp_servers

  vpc_tags = local.vpc_inspection_tags_failover
}

# module "vpc_inspection_endpoints_failover" {
#   source    = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
#   version   = "5.21.0"
#   providers = { aws = aws.networking_prd_failover }

#   count = var.create_failover_region ? 1 : 0

#   vpc_id = module.vpc_inspection_failover[0].vpc_id

#   create_security_group = false
#   # create_security_group      = true
#   # security_group_name_prefix = "${local.resource_name_stub_failover}-${var.this_slug}-inspection-firewall-sg"
#   # security_group_rules       = { ingress_https = { cidr_blocks = ["0.0.0.0/0"] } }

#   endpoints = {
#     network-firewall-fips = {
#       service             = "network-firewall-fips"
#       private_dns_enabled = true
#       subnet_ids          = module.vpc_inspection_failover[0].private_subnets
#       security_group_ids  = [module.sg_inspection_main_failover[0].security_group_id]
#     }
#   }
# }

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_inspection_to_tgw_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  subnet_ids         = module.vpc_inspection_failover[0].intra_subnets
  transit_gateway_id = aws_ec2_transit_gateway.tgw_failover[0].id
  vpc_id             = module.vpc_inspection_failover[0].vpc_id

  appliance_mode_support             = "enable"
  dns_support                        = "enable"
  security_group_referencing_support = "enable"

  # transit_gateway_default_route_table_association = false
  # transit_gateway_default_route_table_propagation = false

  tags = { Name = "${local.resource_name_stub_failover}-${var.this_slug}-tgw-attach-inspection-vpc" }
}

resource "aws_route" "inspection_intra_to_firewall_endpoint_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? length(module.vpc_inspection_failover[0].private_route_table_ids) : 0

  route_table_id         = module.vpc_inspection_failover[0].intra_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id = flatten([
    for s in tolist(module.network_firewall_failover[0].status[0].sync_states) : [
      for a in s.attachment : a.endpoint_id
    ]
  ])[count.index]
}

resource "aws_route" "inspection_private_to_tgw_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? length(module.vpc_inspection_failover[0].private_route_table_ids) : 0

  route_table_id         = module.vpc_inspection_failover[0].private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_failover[0].id
}