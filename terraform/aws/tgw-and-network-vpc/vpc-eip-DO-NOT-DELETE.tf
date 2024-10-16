resource "aws_eip" "vpc_nat_primary" {
  provider = aws.network

  count = length(local.vpc_azs_primary)
  domain = "vpc"
  tags = { "Name" = "${local.resource_name_stub}-${var.region.primary_short}-${local.this_slug}-vpc-eip-${count.index}" }

  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE
}

resource "aws_eip" "vpc_nat_failover" {
  provider = aws.network_failover

  count = length(local.vpc_azs_primary)
  domain = "vpc"
  tags = { "Name" = "${local.resource_name_stub}-${var.region.failover_short}-${local.this_slug}-vpc-eip-${count.index}" }

  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE
}