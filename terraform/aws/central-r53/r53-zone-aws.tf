resource "aws_route53_zone" "central_aws_prd" {
  provider = aws.this

  name = "aws.${local.central_zone_root}"
}

resource "aws_route53_record" "central_aws_ns_prd" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = aws_route53_zone.central_aws_prd.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_prd.name_servers
}

resource "aws_route53_record" "central_aws_wildcard_prd" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "*.${local.central_zone_root}"
  type    = "CNAME"
  ttl     = 86400
  records = [aws_route53_zone.central_aws_prd.name]
}

# ---

resource "aws_route53_zone" "central_aws_stg" {
  provider = aws.this

  name = "awsstg.${local.central_zone_root}"
}

resource "aws_route53_record" "central_aws_ns_stg" {
  provider = aws.this

  zone_id = aws_route53_zone.central_aws_prd.zone_id
  name    = aws_route53_zone.central_aws_stg.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_stg.name_servers
}

resource "aws_route53_record" "central_aws_wildcard_stg" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "*.awsstg.${local.central_zone_root}"
  type    = "CNAME"
  ttl     = 86400
  records = [aws_route53_zone.central_aws_stg.name]
}

# ---

resource "aws_route53_zone" "central_aws_tst" {
  provider = aws.this

  name = "awstst.${local.central_zone_root}"
}

resource "aws_route53_record" "central_aws_ns_tst" {
  provider = aws.this

  zone_id = aws_route53_zone.central_aws_prd.zone_id
  name    = aws_route53_zone.central_aws_tst.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_tst.name_servers
}

resource "aws_route53_record" "central_aws_wildcard_tst" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "*.awstst.${local.central_zone_root}"
  type    = "CNAME"
  ttl     = 86400
  records = [aws_route53_zone.central_aws_tst.name]
}

# ---

resource "aws_route53_zone" "central_aws_dev" {
  provider = aws.this

  name = "awsdev.${local.central_zone_root}"
}

resource "aws_route53_record" "central_aws_ns_dev" {
  provider = aws.this

  zone_id = aws_route53_zone.central_aws_prd.zone_id
  name    = aws_route53_zone.central_aws_dev.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_dev.name_servers
}

resource "aws_route53_record" "central_aws_wildcard_dev" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "*.awsdev.${local.central_zone_root}"
  type    = "CNAME"
  ttl     = 86400
  records = [aws_route53_zone.central_aws_dev.name]
}