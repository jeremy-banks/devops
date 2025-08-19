resource "aws_route" "inspection_intra_to_firewall_endpoint_primary" {
  provider = aws.networking_prd

  count = length(module.vpc_inspection_primary.intra_route_table_ids)

  route_table_id         = module.vpc_inspection_primary.intra_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id = flatten([
    for s in tolist(module.network_firewall_primary.status[0].sync_states) : [
      for a in s.attachment : a.endpoint_id
    ]
  ])[count.index]
}

resource "aws_route" "inspection_private_to_tgw_primary" {
  provider = aws.networking_prd

  count = length(module.vpc_inspection_primary.private_route_table_ids)

  route_table_id         = module.vpc_inspection_primary.private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_primary.id
}