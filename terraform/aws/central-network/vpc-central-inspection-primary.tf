locals {
  vpc_inspection_cidrsubnets_primary = (
    var.vpc_azs_number_used_network == 4 ? cidrsubnets(var.vpc_cidr.central_inspection_prd_primary, 3, 3, 3, 3, 12, 12, 12, 12) :
    var.vpc_azs_number_used_network == 3 ? cidrsubnets(var.vpc_cidr.central_inspection_prd_primary, 2, 2, 2, 12, 12, 12) :
    var.vpc_azs_number_used_network == 2 ? cidrsubnets(var.vpc_cidr.central_inspection_prd_primary, 2, 2, 12, 12) :
    null
  )

  vpc_inspection_private_subnets_primary = (
    var.vpc_azs_number_used_network == 4 ? [local.vpc_inspection_cidrsubnets_primary[0], local.vpc_inspection_cidrsubnets_primary[1], local.vpc_inspection_cidrsubnets_primary[2], local.vpc_inspection_cidrsubnets_primary[3]] :
    var.vpc_azs_number_used_network == 3 ? [local.vpc_inspection_cidrsubnets_primary[0], local.vpc_inspection_cidrsubnets_primary[1], local.vpc_inspection_cidrsubnets_primary[2]] :
    var.vpc_azs_number_used_network == 2 ? [local.vpc_inspection_cidrsubnets_primary[0], local.vpc_inspection_cidrsubnets_primary[1]] :
    null
  )

  vpc_inspection_intra_subnets_primary = (
    var.vpc_azs_number_used_network == 4 ? [local.vpc_inspection_cidrsubnets_primary[4], local.vpc_inspection_cidrsubnets_primary[5], local.vpc_inspection_cidrsubnets_primary[6], local.vpc_inspection_cidrsubnets_primary[7]] :
    var.vpc_azs_number_used_network == 3 ? [local.vpc_inspection_cidrsubnets_primary[3], local.vpc_inspection_cidrsubnets_primary[4], local.vpc_inspection_cidrsubnets_primary[5]] :
    var.vpc_azs_number_used_network == 2 ? [local.vpc_inspection_cidrsubnets_primary[2], local.vpc_inspection_cidrsubnets_primary[3]] :
    null
  )
}

module "vpc_inspection_primary" {
  source    = "terraform-aws-modules/vpc/aws"
  version   = "~> 6.0.1"
  providers = { aws = aws.this }

  name = "${local.resource_name.primary}-vpc-central-inspection"
  cidr = var.vpc_cidr.central_inspection_prd_primary

  azs             = slice(local.vpc_az_ids_primary, 0, var.vpc_azs_number_used_network)
  private_subnets = local.vpc_inspection_private_subnets_primary
  intra_subnets   = local.vpc_inspection_intra_subnets_primary

  private_subnet_suffix = "pvt"
  intra_subnet_suffix   = "tgw"

  create_database_subnet_group    = false
  create_elasticache_subnet_group = false
  create_redshift_subnet_group    = false

  default_route_table_name   = "DO-NOT-USE"
  default_route_table_routes = []

  create_igw = false

  create_multiple_intra_route_tables = true

  default_security_group_name    = "DO-NOT-USE"
  default_security_group_ingress = []
  default_security_group_egress  = []
  default_security_group_tags    = {}

  enable_dhcp_options              = true
  dhcp_options_domain_name_servers = var.dns_servers
  dhcp_options_ntp_servers         = var.ntp_servers
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_inspection_to_tgw_primary" {
  provider = aws.this

  subnet_ids         = module.vpc_inspection_primary.intra_subnets
  transit_gateway_id = aws_ec2_transit_gateway.tgw_primary.id
  vpc_id             = module.vpc_inspection_primary.vpc_id

  appliance_mode_support             = "enable"
  dns_support                        = "enable"
  security_group_referencing_support = "enable"

  # transit_gateway_default_route_table_association = false
  # transit_gateway_default_route_table_propagation = false

  tags = { Name = "vpc-central-inspection-tgw-attach-primary" }
}