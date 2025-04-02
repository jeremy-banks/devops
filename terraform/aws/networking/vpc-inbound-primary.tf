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

  manage_default_route_table = false

  manage_default_security_group  = false
  default_security_group_name    = "NEVER-USE-THIS-SECURITY-GROUP"
  default_security_group_ingress = []
  default_security_group_egress  = []
  default_security_group_tags    = {}

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = false

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