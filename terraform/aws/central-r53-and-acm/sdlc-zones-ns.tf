
resource "aws_route53_zone" "central_aws_sdlc_prd" {
  provider = aws.sdlc_prd

  name = "${var.r53_delegate.sdlc}.${aws_route53_zone.central_aws_prd.name}"
}

resource "aws_route53_record" "central_aws_sdlc_ns_prd" {
  provider = aws.this

  zone_id = aws_route53_zone.central_aws_prd.zone_id
  name    = aws_route53_zone.central_aws_sdlc_prd.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_sdlc_prd.name_servers
}

resource "aws_route53_zone" "central_aws_sdlc_stg" {
  provider = aws.sdlc_stg

  name = "${var.r53_delegate.sdlc}stg.${aws_route53_zone.central_aws_prd.name}"
}

resource "aws_route53_record" "central_aws_sdlc_ns_stg" {
  provider = aws.this

  zone_id = aws_route53_zone.central_aws_prd.zone_id
  name    = aws_route53_zone.central_aws_sdlc_stg.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_sdlc_stg.name_servers
}

resource "aws_route53_zone" "central_aws_sdlc_tst" {
  provider = aws.sdlc_tst

  name = "${var.r53_delegate.sdlc}tst.${aws_route53_zone.central_aws_prd.name}"
}

resource "aws_route53_record" "central_aws_sdlc_ns_tst" {
  provider = aws.this

  zone_id = aws_route53_zone.central_aws_prd.zone_id
  name    = aws_route53_zone.central_aws_sdlc_tst.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_sdlc_tst.name_servers
}

resource "aws_route53_zone" "central_aws_sdlc_dev" {
  provider = aws.sdlc_dev

  name = "${var.r53_delegate.sdlc}dev.${aws_route53_zone.central_aws_prd.name}"
}

resource "aws_route53_record" "central_aws_sdlc_ns_dev" {
  provider = aws.this

  zone_id = aws_route53_zone.central_aws_prd.zone_id
  name    = aws_route53_zone.central_aws_sdlc_dev.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_sdlc_dev.name_servers
}