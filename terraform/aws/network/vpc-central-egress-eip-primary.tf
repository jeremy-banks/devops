resource "aws_eip" "vpc_central_egress_primary_nat" {
  provider = aws.network_prd
  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE

  count = var.azs_number_used_network

  domain = "vpc"
  tags   = { "Name" = "${local.resource_name_stub_primary}-vpc-central-egress-primary-eip-DO-NOT-DELETE-${count.index}" }
}