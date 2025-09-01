resource "aws_route53_zone" "central_aws_sdlc_prd" {
  provider = aws.this

  name = "sdlc.aws.${local.central_zone_root}"
}

resource "aws_route53_record" "central_aws_sdlc_ns_prd" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = aws_route53_zone.central_aws_sdlc_prd.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_sdlc_prd.name_servers
}

resource "aws_route53_record" "central_aws_sdlc_wildcard_prd" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "*.sdlc.aws.${local.central_zone_root}"
  type    = "CNAME"
  ttl     = 86400
  records = [aws_route53_zone.central_aws_sdlc_prd.name]
}

resource "aws_route53_zone" "central_aws_sdlc_stg" {
  provider = aws.this

  name = "sdlcstg.aws.${local.central_zone_root}"
}

resource "aws_route53_record" "central_aws_sdlc_ns_stg" {
  provider = aws.this

  zone_id = aws_route53_zone.central_aws_sdlc_prd.zone_id
  name    = aws_route53_zone.central_aws_sdlc_stg.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_sdlc_stg.name_servers
}

resource "aws_route53_record" "central_aws_sdlc_wildcard_stg" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "*.sdlcstg.aws.${local.central_zone_root}"
  type    = "CNAME"
  ttl     = 86400
  records = [aws_route53_zone.central_aws_sdlc_stg.name]
}

resource "aws_route53_zone" "central_aws_sdlc_tst" {
  provider = aws.this

  name = "sdlctst.aws.${local.central_zone_root}"
}

resource "aws_route53_record" "central_aws_sdlc_ns_tst" {
  provider = aws.this

  zone_id = aws_route53_zone.central_aws_sdlc_prd.zone_id
  name    = aws_route53_zone.central_aws_sdlc_tst.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_sdlc_tst.name_servers
}

resource "aws_route53_record" "central_aws_sdlc_wildcard_tst" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "*.sdlctst.aws.${local.central_zone_root}"
  type    = "CNAME"
  ttl     = 86400
  records = [aws_route53_zone.central_aws_sdlc_tst.name]
}

resource "aws_route53_zone" "central_aws_sdlc_dev" {
  provider = aws.this

  name = "sdlcdev.aws.${local.central_zone_root}"
}

resource "aws_route53_record" "central_aws_sdlc_ns_dev" {
  provider = aws.this

  zone_id = aws_route53_zone.central_aws_sdlc_prd.zone_id
  name    = aws_route53_zone.central_aws_sdlc_dev.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_sdlc_dev.name_servers
}

resource "aws_route53_record" "central_aws_sdlc_wildcard_dev" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "*.sdlcdev.aws.${local.central_zone_root}"
  type    = "CNAME"
  ttl     = 86400
  records = [aws_route53_zone.central_aws_sdlc_dev.name]
}