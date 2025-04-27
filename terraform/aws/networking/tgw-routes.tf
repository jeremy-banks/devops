resource "aws_ec2_transit_gateway_route_table" "pre_inspection_primary" {
  provider = aws.networking_prd

  transit_gateway_id = aws_ec2_transit_gateway.tgw_primary.id

  tags = { Name = "${local.resource_name_stub_primary}-${var.this_slug}-tgw-pre-inspection" }
}

resource "aws_ec2_transit_gateway_route" "pre_inspection_primary" {
  provider = aws.networking_prd

  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_inspection_to_tgw_primary.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.pre_inspection_primary.id
}

resource "aws_ec2_transit_gateway_route_table" "pre_inspection_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.tgw_failover[0].id

  tags = { Name = "${local.resource_name_stub_failover}-${var.this_slug}-tgw-pre-inspection" }
}

resource "aws_ec2_transit_gateway_route" "pre_inspection_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_inspection_to_tgw_failover[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.pre_inspection_failover[0].id
}

# resource "aws_ec2_transit_gateway_route_table" "post_inspection_primary" {
#   provider = aws.networking_prd

#   transit_gateway_id = aws_ec2_transit_gateway.tgw_primary.id

#   tags = { Name = "${local.resource_name_stub_primary}-${var.this_slug}-tgw-post-inspection" }
# }

# resource "aws_ec2_transit_gateway_route" "post_inspection_primary_outbound" {
#   provider = aws.networking_prd

#   destination_cidr_block         = "0.0.0.0/0"
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_outbound_to_tgw_primary.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.post_inspection_primary.id
# }

# resource "aws_ec2_transit_gateway_route_table" "pre_inspection_failover" {
#   provider = aws.networking_prd_failover

#   count = var.create_failover_region ? 1 : 0

#   transit_gateway_id = aws_ec2_transit_gateway.tgw_failover[0].id

#   tags = { Name = "${local.resource_name_stub_primary}-${var.this_slug}-tgw-pre-inspection" }
# }

# resource "aws_ec2_transit_gateway_route" "pre_inspection_failover" {
#   provider = aws.networking_prd_failover

#   count = var.create_failover_region ? 1 : 0

#   destination_cidr_block         = "0.0.0.0/0"
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_inspection_to_tgw_failover[0].id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.pre_inspection_failover[0].id
# }

# resource "aws_ec2_transit_gateway_route_table" "post_inspection_failover" {
#   provider = aws.networking_prd_failover

#   count = var.create_failover_region ? 1 : 0

#   transit_gateway_id = aws_ec2_transit_gateway.tgw_failover[0].id

#   tags = { Name = "${local.resource_name_stub_primary}-${var.this_slug}-tgw-post-inspection" }
# }