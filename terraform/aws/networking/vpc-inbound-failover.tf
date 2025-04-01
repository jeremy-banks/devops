module "vpc_inbound_failover" {
  source    = "terraform-aws-modules/vpc/aws"
  version   = "5.19.0"
  providers = { aws = aws.network_prd_failover }

  count = var.create_failover_region ? 1 : 0

  enable_nat_gateway = false

  name                = "${local.resource_name_stub_failover}-vpc-inbound-failover"
  public_subnet_names = [for i in range(6) : "${format("%s-pvt-", "${local.resource_name_stub_failover}-vpc-inbound-failover")}${i}"]

  cidr = var.vpc_cidr_infrastructure.inbound_failover
  azs  = slice(var.availability_zones.failover, 0, var.availability_zones_num_used)

  public_subnets = (
    var.availability_zones_num_used == 6 ? cidrsubnets(var.vpc_cidr_infrastructure.inbound_failover, 4, 4, 4, 4, 4, 4) :
    var.availability_zones_num_used == 5 ? cidrsubnets(var.vpc_cidr_infrastructure.inbound_failover, 4, 4, 4, 4, 4) :
    var.availability_zones_num_used == 4 ? cidrsubnets(var.vpc_cidr_infrastructure.inbound_failover, 2, 2, 2, 2) :
    var.availability_zones_num_used == 3 ? cidrsubnets(var.vpc_cidr_infrastructure.inbound_failover, 2, 2, 2) :
    cidrsubnets(var.vpc_cidr_infrastructure.inbound_failover, 1, 1)
  )

  manage_default_security_group  = true
  default_security_group_name    = "NEVER-USE-THIS-SECURITY-GROUP"
  default_security_group_ingress = []
  default_security_group_egress  = []
  default_security_group_tags    = {}

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_dhcp_options              = true
  dhcp_options_domain_name_servers = [replace(var.vpc_cidr_infrastructure.inbound_failover, "0/16", "2")]
  dhcp_options_ntp_servers         = var.ntp_servers

  vpc_tags = local.vpc_tags_failover
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_inbound_to_tgw_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region ? 1 : 0

  subnet_ids                                      = module.vpc_inbound_failover[0].public_subnets
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw_failover[0].id
  vpc_id                                          = module.vpc_inbound_failover[0].vpc_id
  appliance_mode_support                          = "enable"
  dns_support                                     = "enable"
  security_group_referencing_support              = "enable"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true

  tags = { Name = "inbound-vpc-attach-tgw-failover" }
}