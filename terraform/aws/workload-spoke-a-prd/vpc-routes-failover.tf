resource "aws_route" "private_to_tgw_failover" {
  provider = aws.workload_spoke_a_prd_failover

  count = var.create_failover_region ? length(module.vpc_failover[0].private_route_table_ids) : 0

  route_table_id         = module.vpc_failover[0].private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw_failover[0].id
}

resource "aws_route" "intra_to_tgw_failover" {
  provider = aws.workload_spoke_a_prd_failover

  count = var.create_failover_region ? length(module.vpc_failover[0].intra_route_table_ids) : 0

  route_table_id         = module.vpc_failover[0].intra_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw_failover[0].id
}