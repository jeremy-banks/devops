resource "aws_route" "inspection_intra_to_firewall_endpoint_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region_networking ? length(module.vpc_inspection_failover[0].private_route_table_ids) : 0

  route_table_id         = module.vpc_inspection_failover[0].intra_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id = flatten([
    for s in tolist(module.network_firewall_failover[0].status[0].sync_states) : [
      for a in s.attachment : a.endpoint_id
    ]
  ])[count.index]
}

resource "aws_route" "inspection_private_to_tgw_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region_networking ? length(module.vpc_inspection_failover[0].private_route_table_ids) : 0

  route_table_id         = module.vpc_inspection_failover[0].private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_failover[0].id
}