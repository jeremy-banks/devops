locals {
  vpc_inspection_cidrsubnets_primary = (
    var.azs_number_used_network == 4 ? cidrsubnets(var.vpc_cidr_infrastructure.central_inspection_primary, 3, 3, 3, 3, 12, 12, 12, 12) :
    var.azs_number_used_network == 3 ? cidrsubnets(var.vpc_cidr_infrastructure.central_inspection_primary, 2, 2, 2, 12, 12, 12) :
    var.azs_number_used_network == 2 ? cidrsubnets(var.vpc_cidr_infrastructure.central_inspection_primary, 2, 2, 12, 12) :
    null
  )

  vpc_inspection_private_subnets_primary = (
    var.azs_number_used_network == 4 ? [local.vpc_inspection_cidrsubnets_primary[0], local.vpc_inspection_cidrsubnets_primary[1], local.vpc_inspection_cidrsubnets_primary[2], local.vpc_inspection_cidrsubnets_primary[3]] :
    var.azs_number_used_network == 3 ? [local.vpc_inspection_cidrsubnets_primary[0], local.vpc_inspection_cidrsubnets_primary[1], local.vpc_inspection_cidrsubnets_primary[2]] :
    var.azs_number_used_network == 2 ? [local.vpc_inspection_cidrsubnets_primary[0], local.vpc_inspection_cidrsubnets_primary[1]] :
    null
  )

  vpc_inspection_intra_subnets_primary = (
    var.azs_number_used_network == 4 ? [local.vpc_inspection_cidrsubnets_primary[4], local.vpc_inspection_cidrsubnets_primary[5], local.vpc_inspection_cidrsubnets_primary[6], local.vpc_inspection_cidrsubnets_primary[7]] :
    var.azs_number_used_network == 3 ? [local.vpc_inspection_cidrsubnets_primary[3], local.vpc_inspection_cidrsubnets_primary[4], local.vpc_inspection_cidrsubnets_primary[5]] :
    var.azs_number_used_network == 2 ? [local.vpc_inspection_cidrsubnets_primary[2], local.vpc_inspection_cidrsubnets_primary[3]] :
    null
  )

  vpc_inspection_tags_primary = {}
}

module "vpc_inspection_primary" {
  source    = "terraform-aws-modules/vpc/aws"
  version   = "6.0.1"
  providers = { aws = aws.network_prd }

  name = "${local.resource_name_primary}-vpc-central-inspection"
  cidr = var.vpc_cidr_infrastructure.central_inspection_primary

  azs                 = slice(var.azs_primary, 0, var.azs_number_used_network)
  private_subnets     = local.vpc_inspection_private_subnets_primary
  public_subnets      = []
  database_subnets    = []
  elasticache_subnets = []
  redshift_subnets    = []
  intra_subnets       = local.vpc_inspection_intra_subnets_primary

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

  enable_dhcp_options = true
  # dhcp_options_domain_name_servers = [replace(var.vpc_cidr_infrastructure.central_inspection_primary, "0/16", "2")]
  dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]
  dhcp_options_ntp_servers         = var.ntp_servers

  vpc_tags = local.vpc_inspection_tags_primary
}

# module "vpc_inspection_endpoints_primary" {
#   source    = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
#   version   = "6.0.1"
#   providers = { aws = aws.network_prd }

#   vpc_id = module.vpc_inspection_primary.vpc_id

#   create_security_group = false
#   # create_security_group      = true
#   # security_group_name_prefix = "${local.resource_name_primary}-central-inspection-firewall-sg"
#   # security_group_rules       = { ingress_https = { cidr_blocks = ["0.0.0.0/0"] } }

#   endpoints = {
#     network-firewall-fips = {
#       service             = "network-firewall-fips"
#       private_dns_enabled = true
#       subnet_ids          = module.vpc_inspection_primary.private_subnets
#       security_group_ids  = [module.sg_inspection_main_primary.security_group_id]
#     }
#   }
# }

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_inspection_to_tgw_primary" {
  provider = aws.network_prd

  subnet_ids         = module.vpc_inspection_primary.intra_subnets
  transit_gateway_id = aws_ec2_transit_gateway.tgw_primary.id
  vpc_id             = module.vpc_inspection_primary.vpc_id

  appliance_mode_support             = "enable"
  dns_support                        = "enable"
  security_group_referencing_support = "enable"

  # transit_gateway_default_route_table_association = false
  # transit_gateway_default_route_table_propagation = false

  tags = { Name = "${local.resource_name_primary}-tgw-attach" }
}