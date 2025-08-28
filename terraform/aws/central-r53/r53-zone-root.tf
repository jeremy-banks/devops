locals {
  central_zone_root = "cockydevops.com"
}

resource "aws_route53_zone" "central_root" {
  provider = aws.network_prd

  name = local.central_zone_root
}