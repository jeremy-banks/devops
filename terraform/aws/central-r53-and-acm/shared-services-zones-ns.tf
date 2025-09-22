resource "aws_route53_zone" "shared_services_prd" {
  provider = aws.shared_services_prd

  name = "${var.r53_delegate.shared_services}.${aws_route53_zone.aws_prd.name}"
}

resource "aws_route53_record" "shared_services_ns_prd" {
  provider = aws.this

  zone_id = aws_route53_zone.aws_prd.zone_id
  name    = aws_route53_zone.shared_services_prd.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.shared_services_prd.name_servers
}

resource "aws_route53_zone" "shared_services_stg" {
  provider = aws.shared_services_stg

  name = "${var.r53_delegate.shared_services}-stg.${aws_route53_zone.aws_prd.name}"
}

resource "aws_route53_record" "shared_services_ns_stg" {
  provider = aws.this

  zone_id = aws_route53_zone.aws_prd.zone_id
  name    = aws_route53_zone.shared_services_stg.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.shared_services_stg.name_servers
}