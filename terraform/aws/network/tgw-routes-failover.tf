resource "aws_ec2_transit_gateway_route_table" "pre_inspection_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region_network ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.tgw_failover[0].id

  tags = { Name = "${local.resource_name_failover}-tgw-pre-inspection" }
}

resource "aws_ec2_transit_gateway_route" "pre_inspection_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region_network ? 1 : 0

  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_inspection_to_tgw_failover[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.pre_inspection_failover[0].id
}

resource "aws_ec2_transit_gateway_route_table_association" "vpc_central_egress_to_tgw_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region_network ? 1 : 0

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_central_egress_to_tgw_failover[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.pre_inspection_failover[0].id
}

resource "aws_ec2_transit_gateway_route_table" "post_inspection_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region_network ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.tgw_failover[0].id

  tags = { Name = "${local.resource_name_failover}-tgw-post-inspection" }
}

resource "aws_ec2_transit_gateway_route" "post_inspection_central_egress_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region_network ? 1 : 0

  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_central_egress_to_tgw_failover[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.post_inspection_failover[0].id
}

resource "aws_ec2_transit_gateway_route_table_association" "vpc_inspection_to_tgw_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region_network ? 1 : 0

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_inspection_to_tgw_failover[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.post_inspection_failover[0].id
}