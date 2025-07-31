resource "aws_route" "private_to_tgw_primary" {
  provider = aws.workload_spoke_a_prd

  count = length(module.vpc_primary.private_route_table_ids)

  route_table_id         = module.vpc_primary.private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw_primary.id
}

resource "aws_route" "public_to_tgw_primary" {
  provider = aws.workload_spoke_a_prd

  count = length(module.vpc_primary.public_route_table_ids)

  route_table_id         = module.vpc_primary.public_route_table_ids[count.index]
  destination_cidr_block = var.vpc_cidr_infrastructure.transit_gateway
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw_primary.id
}

resource "aws_route" "intra_to_tgw_primary" {
  provider = aws.workload_spoke_a_prd

  count = length(module.vpc_primary.intra_route_table_ids)

  route_table_id         = module.vpc_primary.intra_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw_primary.id
}