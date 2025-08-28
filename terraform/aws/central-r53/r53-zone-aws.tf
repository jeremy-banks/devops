resource "aws_route53_zone" "central_aws_prd" {
  provider = aws.network_prd

  name = "aws.${local.central_zone_root}"
}

resource "aws_route53_record" "central_aws_ns_prd" {
  provider = aws.network_prd

  zone_id = aws_route53_zone.central_root.zone_id
  name    = aws_route53_zone.central_aws_prd.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_prd.name_servers
}

resource "aws_route53_record" "central_aws_wildcard_prd" {
  provider = aws.network_prd

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "*.${local.central_zone_root}"
  type    = "CNAME"
  ttl     = 86400
  records = [aws_route53_zone.central_aws_prd.name]
}