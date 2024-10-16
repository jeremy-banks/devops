data "aws_organizations_organization" "current" {
  provider = aws.org
}

data "aws_organizations_organizational_unit" "infrastructure" {
  provider = aws.org

  parent_id = data.aws_organizations_organization.current.roots[0].id
  name      = "infrastructure"
}

data "aws_organizations_organizational_unit" "security" {
  provider = aws.org

  parent_id = data.aws_organizations_organization.current.roots[0].id
  name      = "security"
}

data "aws_organizations_organizational_unit" "workloads" {
  parent_id = data.aws_organizations_organization.current.roots[0].id
  name      = "workloads"
}

module "tgw_primary" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "2.12.2"
  providers = { aws = aws.network }

  name = "${local.resource_name_stub}-${var.region.primary_short}-network-tgw"

  amazon_side_asn = var.tgw_asn.primary
  enable_auto_accept_shared_attachments = true
  create_tgw_routes = false

  ram_name = "${local.resource_name_stub}-${var.region.primary_short}-network-tgw"
  ram_allow_external_principals = false
  ram_principals = [
    data.aws_organizations_organizational_unit.infrastructure.arn,
    data.aws_organizations_organizational_unit.security.arn,
    data.aws_organizations_organizational_unit.workloads.arn,
  ]
}

module "tgw_failover" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "2.12.2"
  providers = { aws = aws.network_failover }

  name = "${local.resource_name_stub}-${var.region.failover_short}-network-tgw"

  amazon_side_asn = var.tgw_asn.failover
  enable_auto_accept_shared_attachments = true
  create_tgw_routes = false

  ram_name = "${local.resource_name_stub}-${var.region.failover_short}-network-tgw"
  ram_allow_external_principals = false
  ram_principals = [
    data.aws_organizations_organizational_unit.infrastructure.arn,
    data.aws_organizations_organizational_unit.security.arn,
    data.aws_organizations_organizational_unit.workloads.arn,
  ]
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