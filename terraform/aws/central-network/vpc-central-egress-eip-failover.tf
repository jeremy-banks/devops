resource "aws_eip" "vpc_central_egress_failover_nat" {
  provider = aws.this_failover
  lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE

  count = var.create_failover_region_network ? var.vpc_azs_number_used_network : 0

  domain = "vpc"
  tags   = { "Name" = "${local.resource_name.failover}-vpc-central-egress-eip-DO-NOT-DELETE-${count.index}" }
}