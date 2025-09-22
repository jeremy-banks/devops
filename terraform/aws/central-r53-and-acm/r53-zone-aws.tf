resource "aws_route53_zone" "aws_prd" {
  provider = aws.this

  name = "aws.${aws_route53_zone.central_root.name}"
}

resource "aws_route53_record" "aws_ns_prd" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = aws_route53_zone.aws_prd.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.aws_prd.name_servers
}

resource "aws_route53_zone" "aws_stg" {
  provider = aws.this

  name = "aws-stg.${aws_route53_zone.central_root.name}"
}

resource "aws_route53_record" "aws_ns_stg" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = aws_route53_zone.aws_stg.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.aws_stg.name_servers
}
