data "aws_ec2_transit_gateway" "tgw_primary" {
  provider = aws.sdlc_stg
  filter {
    name   = "options.amazon-side-asn"
    values = [var.tgw_asn.primary]
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_primary" {
  provider = aws.sdlc_stg

  subnet_ids                                      = module.vpc_primary.private_subnets
  transit_gateway_id                              = data.aws_ec2_transit_gateway.tgw_primary[0].id
  vpc_id                                          = module.vpc_primary.vpc_id
  dns_support                                     = "enable"
  security_group_referencing_support              = "enable"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
}

resource "aws_ec2_tag" "tgw_primary" {
  provider    = aws.sdlc_stg

  resource_id = data.aws_ec2_transit_gateway.tgw_primary[0].id
  key         = "Name"
  value       = "${local.resource_name_stub_primary}-network-tgw"
}

data "aws_ec2_transit_gateway" "tgw_failover" {
  provider = aws.sdlc_stg_failover
  filter {
    name   = "options.amazon-side-asn"
    values = [var.tgw_asn.failover]
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_failover" {
  provider = aws.sdlc_stg_failover

  subnet_ids                                      = module.vpc_failover.private_subnets
  transit_gateway_id                              = data.aws_ec2_transit_gateway.tgw_failover.id
  vpc_id                                          = module.vpc_failover.vpc_id
  dns_support                                     = "enable"
  security_group_referencing_support              = "enable"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
}

resource "aws_ec2_tag" "tgw_failover" {
  provider    = aws.sdlc_stg_failover

  resource_id = data.aws_ec2_transit_gateway.tgw_failover.id
  key         = "Name"
  value       = "${local.resource_name_stub_failover}-network-tgw"
}