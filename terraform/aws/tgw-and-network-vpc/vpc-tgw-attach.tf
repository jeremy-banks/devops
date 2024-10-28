resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_primary" {
  provider = aws.network

  count = 1

  subnet_ids                                      = module.vpc_primary[0].private_subnets
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw_primary[0].id
  vpc_id                                          = module.vpc_primary[0].vpc_id
  dns_support                                     = "enable"
  security_group_referencing_support              = "enable"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_failover" {
  provider = aws.network_failover

  count = var.vpc_cidr_substitute_failover != "" ? 1 : 0

  subnet_ids                                      = module.vpc_failover[0].private_subnets
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw_failover[0].id
  vpc_id                                          = module.vpc_failover[0].vpc_id
  dns_support                                     = "enable"
  security_group_referencing_support              = "enable"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
}