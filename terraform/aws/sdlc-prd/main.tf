data "aws_caller_identity" "current" {}

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

locals {
  unique_id = substr(sha256("foo${data.aws_caller_identity.current.account_id}"), 0, 8)
}