resource "aws_ec2_transit_gateway" "tgw_primary" {
  provider = aws.network_prd

  amazon_side_asn                = var.tgw_asn.primary
  auto_accept_shared_attachments = "enable"
  # default_route_table_association    = "enable"
  # default_route_table_propagation    = "enable"
  default_route_table_association    = "disable"
  default_route_table_propagation    = "disable"
  description                        = "${local.resource_name_primary}-${var.this_slug}-tgw"
  dns_support                        = "enable"
  security_group_referencing_support = "enable"

  tags = { "Name" = "${local.resource_name_primary}-${var.this_slug}-tgw" }
}

resource "aws_ec2_transit_gateway" "tgw_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region_network ? 1 : 0

  amazon_side_asn                = var.tgw_asn.failover
  auto_accept_shared_attachments = "enable"
  # default_route_table_association    = "enable"
  # default_route_table_propagation    = "enable"
  default_route_table_association    = "disable"
  default_route_table_propagation    = "disable"
  description                        = "${local.resource_name_failover}-${var.this_slug}-tgw"
  dns_support                        = "enable"
  security_group_referencing_support = "enable"

  tags = { "Name" = "${local.resource_name_failover}-${var.this_slug}-tgw" }
}

resource "aws_ec2_transit_gateway_peering_attachment" "tgw_peering" {
  provider = aws.network_prd_failover

  count = var.create_failover_region_network ? 1 : 0

  peer_region             = var.region_primary.full
  peer_transit_gateway_id = aws_ec2_transit_gateway.tgw_primary.id
  transit_gateway_id      = aws_ec2_transit_gateway.tgw_failover[0].id

  tags = { Name = "${local.resource_name_failover}-${var.this_slug}-tgw-peer-requester" }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "tgw_peering" {
  provider = aws.network_prd

  count = var.create_failover_region_network ? 1 : 0

  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.tgw_peering[0].id

  tags = { Name = "${local.resource_name_primary}-${var.this_slug}-tgw-peer-accepter" }
}

resource "aws_ec2_transit_gateway_route_table" "cross_region_primary" {
  provider = aws.network_prd

  count = var.create_failover_region_network ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.tgw_primary.id

  tags = { Name = "${local.resource_name_primary}-${var.this_slug}-tgw-cross-region-primary" }
}

resource "aws_ec2_transit_gateway_route_table" "cross_region_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region_network ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.tgw_failover[0].id

  tags = { Name = "${local.resource_name_failover}-${var.this_slug}-tgw-cross-region-failover" }
}