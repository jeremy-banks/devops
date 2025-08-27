locals {
  central_zone_root = "cockydevops.com"
}

resource "aws_route53_zone" "central_zone_root" {
  provider = aws.network_prd

  name = local.central_zone_root
}

resource "aws_route53_record" "wildcard_root_to_aws" {
  provider = aws.network_prd

  zone_id = aws_route53_zone.central_zone_root.zone_id
  name    = "*.${local.central_zone_root}"
  type    = "CNAME"
  ttl     = 86400
  records = [aws_route53_zone.central_zone_aws_prd.name]
}