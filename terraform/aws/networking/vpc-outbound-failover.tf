module "vpc_outbound_failover" {
  source    = "terraform-aws-modules/vpc/aws"
  version   = "5.19.0"
  providers = { aws = aws.network_prd_failover }

  enable_nat_gateway     = true
  reuse_nat_ips          = true
  one_nat_gateway_per_az = true
  external_nat_ip_ids    = aws_eip.vpc_outbound_failover_nat[*].id
  external_nat_ips       = aws_eip.vpc_outbound_failover_nat[*].public_ip

  name                = "${local.resource_name_stub_failover}-vpc-outbound-failover"
  public_subnet_names = [for i in range(6) : "${format("%s-pub-", "${local.resource_name_stub_failover}-vpc-outbound-failover")}${i}"]

  cidr = var.vpc_cidr_infrastructure.outbound_failover
  azs  = slice(var.availability_zones.failover, 0, var.availability_zones_num_used)

  public_subnets = (
    var.availability_zones_num_used == 6 ? cidrsubnets(var.vpc_cidr_infrastructure.outbound_failover, 4, 4, 4, 4, 4, 4) :
    var.availability_zones_num_used == 5 ? cidrsubnets(var.vpc_cidr_infrastructure.outbound_failover, 4, 4, 4, 4, 4) :
    var.availability_zones_num_used == 4 ? cidrsubnets(var.vpc_cidr_infrastructure.outbound_failover, 2, 2, 2, 2) :
    var.availability_zones_num_used == 3 ? cidrsubnets(var.vpc_cidr_infrastructure.outbound_failover, 2, 2, 2) :
    cidrsubnets(var.vpc_cidr_infrastructure.outbound_failover, 1, 1)
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
  dhcp_options_domain_name_servers = [replace(var.vpc_cidr_infrastructure.outbound_failover, "0/16", "2")]
  dhcp_options_ntp_servers         = var.ntp_servers

  vpc_tags = local.vpc_tags_failover
}