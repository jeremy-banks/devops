resource "aws_ec2_transit_gateway" "tgw_primary" {
  provider = aws.this

  amazon_side_asn                = var.tgw_asn.primary
  auto_accept_shared_attachments = "enable"
  # default_route_table_association    = "enable"
  # default_route_table_propagation    = "enable"
  default_route_table_association    = "disable"
  default_route_table_propagation    = "disable"
  description                        = "tgw-primary"
  dns_support                        = "enable"
  security_group_referencing_support = "enable"

  tags = { "Name" = "tgw-primary" }
}

resource "aws_ec2_transit_gateway" "tgw_failover" {
  provider = aws.this_failover

  count = var.create_failover_region_network ? 1 : 0

  amazon_side_asn                = var.tgw_asn.failover
  auto_accept_shared_attachments = "enable"
  # default_route_table_association    = "enable"
  # default_route_table_propagation    = "enable"
  default_route_table_association    = "disable"
  default_route_table_propagation    = "disable"
  description                        = "tgw-failover"
  dns_support                        = "enable"
  security_group_referencing_support = "enable"

  tags = { "Name" = "tgw-failover" }
}

resource "aws_ec2_transit_gateway_peering_attachment" "tgw_peering" {
  provider = aws.this_failover

  count = var.create_failover_region_network ? 1 : 0

  peer_region             = var.region_primary.full
  peer_transit_gateway_id = aws_ec2_transit_gateway.tgw_primary.id
  transit_gateway_id      = aws_ec2_transit_gateway.tgw_failover[0].id

  tags = { Name = "tgw-peer-requester-failover" }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "tgw_peering" {
  provider = aws.this

  count = var.create_failover_region_network ? 1 : 0

  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.tgw_peering[0].id

  tags = { Name = "tgw-peer-accepter-primary" }
}

resource "aws_ec2_transit_gateway_route_table" "cross_region_primary" {
  provider = aws.this

  count = var.create_failover_region_network ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.tgw_primary.id

  tags = { Name = "tgw-cross-region-primary" }
}

resource "aws_ec2_transit_gateway_route_table" "cross_region_failover" {
  provider = aws.this_failover

  count = var.create_failover_region_network ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.tgw_failover[0].id

  tags = { Name = "tgw-cross-region-failover" }
}