resource "aws_eip" "vpc_nat_primary" {
  provider = aws.network

  count = 3
  domain = "vpc"
  tags = { "Name" = "${local.resource_name_prefix_env_region_primary_abbr}-${count.index}" }

  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE
}

resource "aws_eip" "vpc_nat_failover" {
  provider = aws.network_failover

  count = 3
  domain = "vpc"
  tags = { "Name" = "${local.resource_name_prefix_env_region_failover_abbr}-${count.index}" }

  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE
}