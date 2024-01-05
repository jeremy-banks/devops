#vpc
# resource "aws_eip" "tgw_vpc_nat_primary" {
#   provider = aws.network

#   count = 2
#   domain = "vpc"
#   tags = { "Name" = "${local.resource_name_env_stub}-primary-${count.index}" }

#   # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE
# }

# module "tgw_vpc_primary" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "5.4.0"

#   providers = { aws = aws.network }

#   reuse_nat_ips = true
#   external_nat_ip_ids = aws_eip.tgw_vpc_nat_primary[*].id

#   name = "${local.resource_name_env_stub}-tgw-vpc-primary"
#   public_subnet_suffix = "pub"
#   private_subnet_suffix = "pvt"
#   cidr = "${var.vpc_prefixes.network_tgw.primary}.0.0/16"

#   azs = var.availability_zones.primary
#   public_subnets = [
#     "${var.vpc_prefixes.network_tgw.primary}.${var.vpc_suffixes.subnet_public_a}",
#     "${var.vpc_prefixes.network_tgw.primary}.${var.vpc_suffixes.subnet_public_b}",
#   ]
#   private_subnets = [
#     "${var.vpc_prefixes.network_tgw.primary}.${var.vpc_suffixes.subnet_private_a}",
#     "${var.vpc_prefixes.network_tgw.primary}.${var.vpc_suffixes.subnet_private_b}",
#   ]

#   # public_subnet_tags = { "kubernetes.io/role/elb" = 1 }
#   # private_subnet_tags = { "kubernetes.io/role/internal-elb" = 1 }
#   # vpc_tags = {
#   #   "${local.resource_name_env_stub}-cluster-primary-blue"   = "shared"
#   #   "${local.resource_name_env_stub}-cluster-primary-green"  = "shared"
#   # }

#   manage_default_security_group = true
#   default_security_group_name = "NEVER-USE-THIS-SECURITY-GROUP"
#   default_security_group_ingress = []
#   default_security_group_egress = []

#   enable_dns_hostnames = true
#   enable_dns_support   = true

#   enable_dhcp_options = true
#   dhcp_options_domain_name_servers = concat(["${var.vpc_prefixes.network_tgw.primary}.0.2"], local.vpc_domain_name_servers)
#   dhcp_options_ntp_servers = local.vpc_ntp_servers
# }

data "aws_organizations_organization" "current" {}

# module "tgw_primary" {
#   source  = "terraform-aws-modules/transit-gateway/aws"
#   version = "2.12.1"

#   providers = { aws = aws.network }

#   name = "${local.resource_name_env_stub}-tgw-primary"

#   enable_auto_accept_shared_attachments = true
#   create_tgw_routes = false

#   ram_name = "${local.resource_name_env_stub}-tgw-ram-primary"
#   ram_allow_external_principals = false
#   ram_principals = [data.aws_organizations_organization.current.arn]
# }

# module "tgw_failover" {
#   source  = "terraform-aws-modules/transit-gateway/aws"
#   version = "2.12.1"

#   providers = { aws = aws.network_failover }

#   name = "${local.resource_name_env_stub}-tgw-failover"

#   enable_auto_accept_shared_attachments = true
#   create_tgw_routes = false

#   ram_name = "${local.resource_name_env_stub}-tgw-ram-failover"
#   ram_allow_external_principals = false
#   ram_principals = [data.aws_organizations_organization.current.arn]
# }

data "aws_caller_identity" "network" {
  provider = aws.network
}

# resource "aws_ec2_transit_gateway_peering_attachment" "primary_to_failover" {
#   provider = aws.network_failover

#   # depends_on = [
#   #   module.tgw_primary,
#   #   module.tgw_failover,
#   # ]

#   peer_account_id         = data.aws_caller_identity.network.account_id
#   peer_region             = var.region.primary
#   peer_transit_gateway_id = module.tgw_failover.ec2_transit_gateway_id
#   transit_gateway_id      = module.tgw_primary.ec2_transit_gateway_id
# }

# resource "aws_ec2_transit_gateway_peering_attachment_accepter" "primary_to_failover" {
#   provider = aws.network

#   transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.primary_to_failover.id
# }

resource "aws_ec2_transit_gateway" "tgw_primary" {
  provider = aws.network

  amazon_side_asn = "64512"  # Example ASN, adjust as needed
  auto_accept_shared_attachments = "enable"
  dns_support = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

}

resource "aws_ec2_transit_gateway" "tgw_failover" {
  provider = aws.network_failover

  amazon_side_asn = "64513"  # Example ASN, adjust as needed
  auto_accept_shared_attachments = "enable"
  dns_support = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

}

resource "aws_ec2_transit_gateway_peering_attachment" "tgw_peering" {
  provider = aws.network_failover

  peer_account_id                     = data.aws_caller_identity.network.account_id
  peer_region                         = var.region.primary
  peer_transit_gateway_id             = aws_ec2_transit_gateway.tgw_primary.id
  transit_gateway_id                  = aws_ec2_transit_gateway.tgw_failover.id
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "tgw_peering" {
  provider = aws.network
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.tgw_peering.id
}