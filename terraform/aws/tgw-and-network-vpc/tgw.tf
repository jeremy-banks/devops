data "aws_organizations_organization" "current" {
  provider = aws.network
}

module "tgw_primary" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "2.12.2"
  providers = { aws = aws.network }

  name = "${local.resource_name_prefix_env_region_primary_abbr}-tgw"

  amazon_side_asn = var.tgw_asn.primary
  enable_auto_accept_shared_attachments = true
  create_tgw_routes = false

  ram_name = "${local.resource_name_prefix_env_region_primary_abbr}-ram-tgw"
  ram_allow_external_principals = false
  ram_principals = [data.aws_organizations_organization.current.arn]
}

module "tgw_failover" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "2.12.2"
  providers = { aws = aws.network_failover }

  name = "${local.resource_name_prefix_env_region_failover_abbr}-tgw"

  amazon_side_asn = var.tgw_asn.failover
  enable_auto_accept_shared_attachments = true
  create_tgw_routes = false

  ram_name = "${local.resource_name_prefix_env_region_failover_abbr}-ram-tgw"
  ram_allow_external_principals = false
  ram_principals = [data.aws_organizations_organization.current.arn]
}

data "aws_caller_identity" "network" {
  provider = aws.network
}

resource "aws_ec2_transit_gateway_peering_attachment" "tgw_peering" {
  provider = aws.network_failover

  peer_account_id                     = data.aws_caller_identity.network.account_id
  peer_region                         = var.region.primary
  peer_transit_gateway_id             = module.tgw_primary.ec2_transit_gateway_id
  transit_gateway_id                  = module.tgw_failover.ec2_transit_gateway_id
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "tgw_peering" {
  provider = aws.network
  
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.tgw_peering.id
}