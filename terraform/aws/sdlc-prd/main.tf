data "aws_caller_identity" "this" {}

data "aws_ec2_transit_gateway" "tgw_primary" {
  provider = aws.network
  filter {
    name   = "options.amazon-side-asn"
    values = [var.tgw_asn.primary]
  }
}

data "aws_ec2_transit_gateway" "tgw_failover" {
  provider = aws.network_failover
  filter {
    name   = "options.amazon-side-asn"
    values = [var.tgw_asn.failover]
  }
}