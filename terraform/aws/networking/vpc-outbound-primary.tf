module "vpc_outbound_primary" {
  source    = "terraform-aws-modules/vpc/aws"
  version   = "5.19.0"
  providers = { aws = aws.network_prd }

  enable_nat_gateway     = true
  reuse_nat_ips          = true
  one_nat_gateway_per_az = true
  external_nat_ip_ids    = aws_eip.vpc_outbound_primary_nat[*].id
  external_nat_ips       = aws_eip.vpc_outbound_primary_nat[*].public_ip

  name                = "${local.resource_name_stub_primary}-vpc-outbound-primary"
  public_subnet_names = [for i in range(6) : "${format("%s-pub-", "${local.resource_name_stub_primary}-vpc-outbound-primary")}${i}"]

  cidr = var.vpc_cidr_infrastructure.outbound_primary
  azs  = slice(var.availability_zones.primary, 0, var.availability_zones_num_used)

  public_subnets = (
    var.availability_zones_num_used == 6 ? cidrsubnets(var.vpc_cidr_infrastructure.outbound_primary, 4, 4, 4, 4, 4, 4) :
    var.availability_zones_num_used == 5 ? cidrsubnets(var.vpc_cidr_infrastructure.outbound_primary, 4, 4, 4, 4, 4) :
    var.availability_zones_num_used == 4 ? cidrsubnets(var.vpc_cidr_infrastructure.outbound_primary, 2, 2, 2, 2) :
    var.availability_zones_num_used == 3 ? cidrsubnets(var.vpc_cidr_infrastructure.outbound_primary, 2, 2, 2) :
    cidrsubnets(var.vpc_cidr_infrastructure.outbound_primary, 1, 1)
  )

  create_private_nat_gateway_route = false

  manage_default_security_group  = true
  default_security_group_name    = "NEVER-USE-THIS-SECURITY-GROUP"
  default_security_group_ingress = []
  default_security_group_egress  = []
  default_security_group_tags    = {}

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_dhcp_options              = true
  dhcp_options_domain_name_servers = [replace(var.vpc_cidr_infrastructure.outbound_primary, "0/16", "2")]
  dhcp_options_ntp_servers         = var.ntp_servers

  vpc_tags = local.vpc_tags_primary
}