resource "aws_eip" "vpc_nat_primary" {
  provider = aws.sdlc_stg

  count = var.vpc_enabled ? length(local.vpc_azs_primary) : 0
  domain = "vpc"
  tags = { "Name" = "${local.vpc_name_primary}-eip-DO-NOT-DELETE-${count.index}" }

  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE
}

resource "aws_eip" "vpc_nat_failover" {
  provider = aws.sdlc_stg_failover

  count = var.vpc_enabled ? length(local.vpc_azs_failover) : 0
  domain = "vpc"
  tags = { "Name" = "${local.vpc_name_failover}-eip-DO-NOT-DELETE-${count.index}" }

  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE
}