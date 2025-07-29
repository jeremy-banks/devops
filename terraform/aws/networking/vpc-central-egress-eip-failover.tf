resource "aws_eip" "vpc_central_egress_failover_nat" {
  provider = aws.networking_prd_failover
  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE

  count = var.create_failover_region ? var.azs_used : 0

  domain = "vpc"
  tags   = { "Name" = "${local.resource_name_stub_failover}-vpc-central-egress-failover-eip-DO-NOT-DELETE-${count.index}" }
}