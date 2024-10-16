resource "aws_eip" "vpc_nat_primary" {
  provider = aws.network

  count = 3
  domain = "vpc"
  tags = { "Name" = "${local.resource_name_stub}-${var.region.failover_short}-${count.index}" }

  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE
}

resource "aws_eip" "vpc_nat_failover" {
  provider = aws.network_failover

  count = 3
  domain = "vpc"
  tags = { "Name" = "${local.resource_name_stub}-${var.region.failover_short}-${count.index}" }

  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE
}