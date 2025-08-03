resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_workload_product_a_to_tgw_primary" {
  provider = aws.workload_product_a_prd

  subnet_ids         = module.vpc_primary.intra_subnets
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw_primary.id
  vpc_id             = module.vpc_primary.vpc_id

  appliance_mode_support             = "disable"
  dns_support                        = "enable"
  security_group_referencing_support = "enable"

  # transit_gateway_default_route_table_association = false
  # transit_gateway_default_route_table_propagation = false

  tags = { Name = "${local.resource_name_stub_primary}-${var.this_slug}-tgw-attach" }
}

resource "aws_ec2_transit_gateway_route_table_association" "vpc_workload_product_a_to_tgw_primary" {
  provider = aws.networking_prd

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_workload_product_a_to_tgw_primary.id
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.tgw_pre_central_inspection_primary.id
}

resource "aws_ec2_transit_gateway_route" "post_central_inspection_workload_product_a_primary_to_primary" {
  provider = aws.networking_prd

  destination_cidr_block         = var.vpc_cidr_infrastructure.workload_product_a_prd_primary
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_workload_product_a_to_tgw_primary.id
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.tgw_post_central_inspection_primary.id
}

resource "aws_ec2_transit_gateway_route" "post_central_inspection_workload_product_a_primary_to_failover" {
  provider = aws.networking_prd

  count = var.create_failover_region ? 1 : 0

  destination_cidr_block         = var.vpc_cidr_infrastructure.workload_product_a_prd_failover
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_peering_attachment.tgw_peer_failover[0].id
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.tgw_post_central_inspection_primary.id
}