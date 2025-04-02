resource "aws_eip" "vpc_outbound_primary_nat" {
  provider = aws.network_prd
  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE

  count = var.azs_used

  domain = "vpc"
  tags   = { "Name" = "${local.resource_name_stub_primary}-vpc-outbound-primary-eip-DO-NOT-DELETE-${count.index}" }
}