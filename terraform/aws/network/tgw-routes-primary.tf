resource "aws_ec2_transit_gateway_route_table" "pre_inspection_primary" {
  provider = aws.network_prd

  transit_gateway_id = aws_ec2_transit_gateway.tgw_primary.id

  tags = { Name = "tgw-pre-inspection-primary" }
}

resource "aws_ec2_transit_gateway_route" "pre_inspection_primary" {
  provider = aws.network_prd

  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_inspection_to_tgw_primary.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.pre_inspection_primary.id
}

resource "aws_ec2_transit_gateway_route_table_association" "vpc_central_egress_to_tgw_primary" {
  provider = aws.network_prd

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_central_egress_to_tgw_primary.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.pre_inspection_primary.id
}

resource "aws_ec2_transit_gateway_route_table" "post_inspection_primary" {
  provider = aws.network_prd

  transit_gateway_id = aws_ec2_transit_gateway.tgw_primary.id

  tags = { Name = "tgw-post-inspection-primary" }
}

resource "aws_ec2_transit_gateway_route" "post_inspection_central_egress_primary" {
  provider = aws.network_prd

  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_central_egress_to_tgw_primary.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.post_inspection_primary.id
}

resource "aws_ec2_transit_gateway_route_table_association" "vpc_inspection_to_tgw_primary" {
  provider = aws.network_prd

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_inspection_to_tgw_primary.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.post_inspection_primary.id
}