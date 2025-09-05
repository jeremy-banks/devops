resource "aws_eip" "vpc_central_egress_primary_nat" {
  provider = aws.this
  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE

  count = var.vpc_azs_number_used_network

  domain = "vpc"
  tags   = { "Name" = "${local.resource_name_primary}-vpc-central-egress-eip-DO-NOT-DELETE-${count.index}" }
}