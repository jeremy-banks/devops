resource "aws_eip" "vpc_nat_primary" {
  provider = aws.sdlc_prd

  count = var.vpc_enabled ? length(local.vpc_azs_primary) : 0
  domain = "vpc"
  tags = { "Name" = "${local.resource_name_stub}-${var.region.primary_short}-${local.this_slug}-vpc-eip-DO-NOT-DELETE-${count.index}" }

  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE
}

resource "aws_eip" "vpc_nat_failover" {
  provider = aws.sdlc_prd_failover

  count = var.vpc_enabled ? length(local.vpc_azs_failover) : 0
  domain = "vpc"
  tags = { "Name" = "${local.resource_name_stub}-${var.region.failover_short}-${local.this_slug}-vpc-eip-DO-NOT-DELETE-${count.index}" }

  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE
}