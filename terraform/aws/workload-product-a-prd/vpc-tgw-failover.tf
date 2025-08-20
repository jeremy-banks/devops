resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_workload_product_a_to_tgw_failover" {
  provider = aws.this_failover

  count = var.create_failover_region ? 1 : 0

  subnet_ids         = module.vpc_failover[0].intra_subnets
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw_failover[0].id
  vpc_id             = module.vpc_failover[0].vpc_id

  appliance_mode_support             = "enable"
  dns_support                        = "enable"
  security_group_referencing_support = "enable"

  # transit_gateway_default_route_table_association = false
  # transit_gateway_default_route_table_propagation = false

  tags = { Name = "${local.resource_name_failover}-tgw-attach" }
}

resource "aws_ec2_transit_gateway_route_table_association" "vpc_workload_product_a_to_tgw_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region ? 1 : 0

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_workload_product_a_to_tgw_failover[0].id
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.tgw_pre_inspection_failover[0].id
}

resource "aws_ec2_transit_gateway_route" "post_inspection_workload_product_a_failover_to_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region ? 1 : 0

  destination_cidr_block         = local.vpc_cidr_failover
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_workload_product_a_to_tgw_failover[0].id
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.tgw_post_inspection_failover[0].id
}

resource "aws_ec2_transit_gateway_route" "post_inspection_workload_product_a_failover_to_primary" {
  provider = aws.network_prd_failover

  count = var.create_failover_region ? 1 : 0

  destination_cidr_block         = local.vpc_cidr_primary
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_peering_attachment.tgw_peer_primary[0].id
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.tgw_post_inspection_failover[0].id
}