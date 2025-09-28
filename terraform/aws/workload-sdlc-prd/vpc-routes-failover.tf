resource "aws_route" "private_to_tgw_failover" {
  provider = aws.this_failover

  count = var.create_failover_region ? length(module.vpc_failover[0].private_route_table_ids) : 0

  route_table_id         = module.vpc_failover[0].private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw_failover[0].id
}

resource "aws_route" "public_to_tgw_failover" {
  provider = aws.this_failover

  count = var.create_failover_region ? length(module.vpc_failover[0].public_route_table_ids) : 0

  route_table_id         = module.vpc_failover[0].public_route_table_ids[count.index]
  destination_cidr_block = var.vpc_cidr.transit_gateway
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw_failover[0].id
}

resource "aws_route" "intra_to_tgw_failover" {
  provider = aws.this_failover

  count = var.create_failover_region ? length(module.vpc_failover[0].intra_route_table_ids) : 0

  route_table_id         = module.vpc_failover[0].intra_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw_failover[0].id
}