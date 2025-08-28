
resource "aws_route53_zone" "central_aws_tst" {
  provider = aws.network_prd

  name = "tst.${aws_route53_zone.central_aws_prd.name}"
}

resource "aws_route53_record" "central_aws_ns_tst" {
  provider = aws.network_prd

  zone_id = aws_route53_zone.central_aws_prd.zone_id
  name    = aws_route53_zone.central_aws_tst.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_tst.name_servers
}

resource "aws_route53_record" "central_aws_wildcard_tst" {
  provider = aws.network_prd

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "*.tst.${local.central_zone_root}"
  type    = "CNAME"
  ttl     = 86400
  records = [aws_route53_zone.central_aws_tst.name]
}