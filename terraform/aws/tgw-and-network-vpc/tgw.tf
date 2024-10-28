resource "aws_ec2_transit_gateway" "tgw_primary" {
  provider = aws.network

  count = 1

  amazon_side_asn = var.tgw_asn.primary
  auto_accept_shared_attachments      = "enable"
  default_route_table_association     = "enable"
  default_route_table_propagation     = "enable"
  description                         = "${local.resource_name_stub_primary}-${local.this_slug}-tgw"
  dns_support                         = "enable"
  security_group_referencing_support  = "enable"
  tags                                = { "Name" = "${local.resource_name_stub_primary}-${local.this_slug}-tgw"}
}

resource "aws_ec2_transit_gateway" "tgw_failover" {
  provider = aws.network_failover

  count = local.create_failover_region != "" ? 1 : 0

  amazon_side_asn = var.tgw_asn.failover
  auto_accept_shared_attachments      = "enable"
  default_route_table_association     = "enable"
  default_route_table_propagation     = "enable"
  description                         = "${local.resource_name_stub_failover}-${local.this_slug}-tgw"
  dns_support                         = "enable"
  security_group_referencing_support  = "enable"
  tags                                = { "Name" = "${local.resource_name_stub_failover}-${local.this_slug}-tgw"}
}

data "aws_caller_identity" "network" {
  provider = aws.network
}

resource "aws_ec2_transit_gateway_peering_attachment" "tgw_peering" {
  provider = aws.network_failover

  count = local.create_failover_region != "" ? 1 : 0

  peer_account_id         = data.aws_caller_identity.network.account_id
  peer_region             = var.region.primary
  peer_transit_gateway_id = aws_ec2_transit_gateway.tgw_primary[0].id
  transit_gateway_id      = aws_ec2_transit_gateway.tgw_failover[0].id
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "tgw_peering" {
  provider = aws.network
  
  count = local.create_failover_region != "" ? 1 : 0

  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.tgw_peering[0].id
}