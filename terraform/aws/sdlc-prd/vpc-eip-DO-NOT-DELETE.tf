resource "aws_eip" "vpc_nat_primary" {
  provider = aws.sdlc_prd
  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE

  count = length(var.availability_zones.primary)
  domain = "vpc"
  tags = { "Name" = "${local.vpc_name_primary}-eip-DO-NOT-DELETE-${count.index}" }
}

resource "aws_eip" "vpc_nat_failover" {
  provider = aws.sdlc_prd_failover
  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE

  count = local.create_failover_region ? length(var.availability_zones.primary) : 0
  domain = "vpc"
  tags = { "Name" = "${local.vpc_name_failover}-eip-DO-NOT-DELETE-${count.index}" }
}