data "aws_caller_identity" "this" { provider = aws.workload_spoke_a_prd }

data "aws_ec2_transit_gateway" "tgw_primary" {
  provider = aws.networking_prd
  filter {
    name   = "options.amazon-side-asn"
    values = [var.tgw_asn.primary]
  }
}

data "aws_ec2_transit_gateway" "tgw_failover" {
  provider = aws.networking_prd_failover
  filter {
    name   = "options.amazon-side-asn"
    values = [var.tgw_asn.failover]
  }
}

locals { unique_id = substr(sha256("foo${data.aws_caller_identity.this.account_id}"), 0, 8) }