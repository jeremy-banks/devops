resource "aws_eip" "vpc_nat_primary" {
  provider = aws.network
  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE

  count = local.vpc_cidr_primary != "" ? local.azs_used_num : 0
  domain = "vpc"
  tags = { "Name" = "${local.vpc_name_primary}-eip-DO-NOT-DELETE-${count.index}" }
}

resource "aws_eip" "vpc_nat_failover" {
  provider = aws.network_failover
  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE

  count = local.create_failover_region ? local.azs_used_num : 0
  domain = "vpc"
  tags = { "Name" = "${local.vpc_name_failover}-eip-DO-NOT-DELETE-${count.index}" }
}