resource "aws_route53_record" "workload_sdlc_prd_www" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "www.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["www.sdlc.aws.${aws_route53_zone.central_root.name}"]
}

resource "aws_route53_record" "workload_sdlc_stg_www" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "www-stg.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["www.sdlc-stg.aws.${aws_route53_zone.central_root.name}"]
}

resource "aws_route53_record" "workload_sdlc_tst_www" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "www-tst.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["www.sdlc-tst.aws.${aws_route53_zone.central_root.name}"]
}

resource "aws_route53_record" "workload_sdlc_dev_www" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "www-dev.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["www.sdlc-dev.aws.${aws_route53_zone.central_root.name}"]
}