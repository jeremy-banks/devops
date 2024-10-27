resource "aws_eip" "vpc_nat_primary" {
  provider = aws.network
  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE

  count = var.vpc_enabled ? ( var.vpc_five9s_enabled ? 3 : 2 ) : 0
  domain = "vpc"
  tags = { "Name" = "${local.resource_name_stub}-${var.region.primary_short}-${local.this_slug}-vpc-eip-DO-NOT-DELETE-${count.index}" }
}

resource "aws_eip" "vpc_nat_failover" {
  provider = aws.network_failover
  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE

  count = var.vpc_enabled && var.vpc_failover_enabled ? ( var.vpc_five9s_enabled ? 3 : 2 ) : 0
  domain = "vpc"
  tags = { "Name" = "${local.resource_name_stub}-${var.region.failover_short}-${local.this_slug}-vpc-eip-DO-NOT-DELETE-${count.index}" }
}