
resource "aws_route53_zone" "central_aws_dev" {
  provider = aws.network_prd

  name = "dev.${aws_route53_zone.central_aws_prd.name}"
}

resource "aws_route53_record" "central_aws_ns_dev" {
  provider = aws.network_prd

  zone_id = aws_route53_zone.central_aws_prd.zone_id
  name    = aws_route53_zone.central_aws_dev.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_dev.name_servers
}

resource "aws_route53_record" "central_aws_wildcard_dev" {
  provider = aws.network_prd

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "*.dev.${local.central_zone_root}"
  type    = "CNAME"
  ttl     = 86400
  records = [aws_route53_zone.central_aws_dev.name]
}