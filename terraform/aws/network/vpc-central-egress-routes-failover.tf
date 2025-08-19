resource "aws_route" "central_egress_pub_to_tgw_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region_network ? length(module.vpc_central_egress_failover[0].public_route_table_ids) : 0

  route_table_id         = module.vpc_central_egress_failover[0].public_route_table_ids[count.index]
  destination_cidr_block = var.vpc_cidr_infrastructure.transit_gateway
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_failover[0].id
}

resource "aws_route" "central_egress_intra_to_tgw_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region_network ? length(module.vpc_central_egress_failover[0].intra_route_table_ids) : 0

  route_table_id         = module.vpc_central_egress_failover[0].intra_route_table_ids[count.index]
  destination_cidr_block = var.vpc_cidr_infrastructure.transit_gateway
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_failover[0].id
}

resource "aws_route" "central_egress_intra_to_nat_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region_network ? length(module.vpc_central_egress_failover[0].intra_route_table_ids) : 0

  route_table_id         = module.vpc_central_egress_failover[0].intra_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = module.vpc_central_egress_failover[0].natgw_ids[count.index]
}