resource "aws_eip" "vpc_nat_primary" {
  provider = aws.sdlc_prd

  count = length(local.vpc_azs_primary)
  domain = "vpc"
  tags = { "Name" = "${local.resource_name_stub}-${var.region.failover_short}-${count.index}" }

  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE
}

resource "aws_eip" "vpc_nat_failover" {
  provider = aws.sdlc_prd_failover

  count = length(local.vpc_azs_primary)
  domain = "vpc"
  tags = { "Name" = "${local.resource_name_stub}-${var.region.failover_short}-${count.index}" }

  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE
}