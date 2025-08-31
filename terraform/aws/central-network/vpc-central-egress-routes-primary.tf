resource "aws_route" "central_egress_pub_to_tgw_primary" {
  provider = aws.network_prd

  count = length(module.vpc_central_egress_primary.public_route_table_ids)

  route_table_id         = module.vpc_central_egress_primary.public_route_table_ids[count.index]
  destination_cidr_block = var.vpc_cidr.transit_gateway
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_primary.id
}

resource "aws_route" "central_egress_intra_to_tgw_primary" {
  provider = aws.network_prd

  count = length(module.vpc_central_egress_primary.intra_route_table_ids)

  route_table_id         = module.vpc_central_egress_primary.intra_route_table_ids[count.index]
  destination_cidr_block = var.vpc_cidr.transit_gateway
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_primary.id
}

resource "aws_route" "central_egress_intra_to_nat_primary" {
  provider = aws.network_prd

  count = length(module.vpc_central_egress_primary.intra_route_table_ids)

  route_table_id         = module.vpc_central_egress_primary.intra_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = module.vpc_central_egress_primary.natgw_ids[count.index]
}