resource "aws_route53_zone" "central_zone_aws_prd" {
  provider = aws.network_prd

  name = "aws.${aws_route53_zone.central_zone_root.name}"
}

resource "aws_route53_zone" "central_zone_aws_stg" {
  provider = aws.network_prd

  name = "stg.${aws_route53_zone.central_zone_aws_prd.name}"
}

resource "aws_route53_record" "central_zone_aws_stg_ns" {
  provider = aws.network_prd

  zone_id = aws_route53_zone.central_zone_aws_prd.zone_id
  name    = aws_route53_zone.central_zone_aws_stg.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_zone_aws_stg.name_servers
}

resource "aws_route53_record" "wildcard_stg_to_aws" {
  provider = aws.network_prd

  zone_id = aws_route53_zone.central_zone_root.zone_id
  name    = "*.stg.${local.central_zone_root}"
  type    = "CNAME"
  ttl     = 86400
  records = ["stg.aws.${local.central_zone_root}"]
}

resource "aws_route53_zone" "central_zone_aws_tst" {
  provider = aws.network_prd

  name = "tst.${aws_route53_zone.central_zone_aws_prd.name}"
}

resource "aws_route53_record" "central_zone_aws_tst_ns" {
  provider = aws.network_prd

  zone_id = aws_route53_zone.central_zone_aws_prd.zone_id
  name    = aws_route53_zone.central_zone_aws_tst.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_zone_aws_tst.name_servers
}

resource "aws_route53_record" "wildcard_tst_to_aws" {
  provider = aws.network_prd

  zone_id = aws_route53_zone.central_zone_root.zone_id
  name    = "*.tst.${local.central_zone_root}"
  type    = "CNAME"
  ttl     = 86400
  records = ["tst.aws.${local.central_zone_root}"]
}

resource "aws_route53_zone" "central_zone_aws_dev" {
  provider = aws.network_prd

  name = "dev.${aws_route53_zone.central_zone_aws_prd.name}"
}

resource "aws_route53_record" "central_zone_aws_dev_ns" {
  provider = aws.network_prd

  zone_id = aws_route53_zone.central_zone_aws_prd.zone_id
  name    = aws_route53_zone.central_zone_aws_dev.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_zone_aws_dev.name_servers
}

resource "aws_route53_record" "wildcard_dev_to_aws" {
  provider = aws.network_prd

  zone_id = aws_route53_zone.central_zone_root.zone_id
  name    = "*.dev.${local.central_zone_root}"
  type    = "CNAME"
  ttl     = 86400
  records = ["dev.aws.${local.central_zone_root}"]
}