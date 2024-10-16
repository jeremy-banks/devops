resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_primary" {
  provider = aws.network

  subnet_ids                          = module.vpc_primary.private_subnets
  transit_gateway_id                  = aws_ec2_transit_gateway.tgw_primary.id
  vpc_id                              = module.vpc_primary.vpc_id
  security_group_referencing_support  = "enable"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_failover" {
  provider = aws.network_failover

  subnet_ids                          = module.vpc_failover.private_subnets
  transit_gateway_id                  = aws_ec2_transit_gateway.tgw_failover.id
  vpc_id                              = module.vpc_failover.vpc_id
  security_group_referencing_support  = "enable"
}