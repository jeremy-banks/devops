locals {
  vpc_central_egress_cidrsubnets_primary = (
    var.vpc_azs_number_used_network == 4 ? cidrsubnets(var.vpc_cidr.central_egress_primary, 3, 3, 3, 3, 12, 12, 12, 12) :
    var.vpc_azs_number_used_network == 3 ? cidrsubnets(var.vpc_cidr.central_egress_primary, 2, 2, 2, 12, 12, 12) :
    var.vpc_azs_number_used_network == 2 ? cidrsubnets(var.vpc_cidr.central_egress_primary, 2, 2, 12, 12) :
    null
  )

  vpc_central_egress_public_subnets_primary = (
    var.vpc_azs_number_used_network == 4 ? [local.vpc_central_egress_cidrsubnets_primary[0], local.vpc_central_egress_cidrsubnets_primary[1], local.vpc_central_egress_cidrsubnets_primary[2], local.vpc_central_egress_cidrsubnets_primary[3]] :
    var.vpc_azs_number_used_network == 3 ? [local.vpc_central_egress_cidrsubnets_primary[0], local.vpc_central_egress_cidrsubnets_primary[1], local.vpc_central_egress_cidrsubnets_primary[2]] :
    var.vpc_azs_number_used_network == 2 ? [local.vpc_central_egress_cidrsubnets_primary[0], local.vpc_central_egress_cidrsubnets_primary[1]] :
    null
  )

  vpc_central_egress_intra_subnets_primary = (
    var.vpc_azs_number_used_network == 4 ? [local.vpc_central_egress_cidrsubnets_primary[4], local.vpc_central_egress_cidrsubnets_primary[5], local.vpc_central_egress_cidrsubnets_primary[6], local.vpc_central_egress_cidrsubnets_primary[7]] :
    var.vpc_azs_number_used_network == 3 ? [local.vpc_central_egress_cidrsubnets_primary[3], local.vpc_central_egress_cidrsubnets_primary[4], local.vpc_central_egress_cidrsubnets_primary[5]] :
    var.vpc_azs_number_used_network == 2 ? [local.vpc_central_egress_cidrsubnets_primary[2], local.vpc_central_egress_cidrsubnets_primary[3]] :
    null
  )

  vpc_central_egress_tags_primary = {}
}

module "vpc_central_egress_primary" {
  source    = "terraform-aws-modules/vpc/aws"
  version   = "6.0.1"
  providers = { aws = aws.network_prd }

  name = "${local.resource_name_primary}-vpc-central-egress"
  cidr = var.vpc_cidr.central_egress_primary

  azs                 = slice(local.vpc_az_ids_primary, 0, var.vpc_azs_number_used_network)
  private_subnets     = []
  public_subnets      = local.vpc_central_egress_public_subnets_primary
  database_subnets    = []
  elasticache_subnets = []
  redshift_subnets    = []
  intra_subnets       = local.vpc_central_egress_intra_subnets_primary

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
  external_nat_ip_ids              = aws_eip.vpc_central_egress_primary_nat[*].id
  external_nat_ips                 = aws_eip.vpc_central_egress_primary_nat[*].public_ip
  create_private_nat_gateway_route = false

  enable_dhcp_options              = true
  dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]
  dhcp_options_ntp_servers         = var.ntp_servers

  vpc_tags = local.vpc_central_egress_tags_primary
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_central_egress_to_tgw_primary" {
  provider = aws.network_prd

  subnet_ids         = module.vpc_central_egress_primary.intra_subnets
  transit_gateway_id = aws_ec2_transit_gateway.tgw_primary.id
  vpc_id             = module.vpc_central_egress_primary.vpc_id

  appliance_mode_support             = "enable"
  dns_support                        = "enable"
  security_group_referencing_support = "enable"

  # transit_gateway_default_route_table_association = false
  # transit_gateway_default_route_table_propagation = false

  tags = { Name = "vpc-central-egress-tgw-attach-primary" }
}