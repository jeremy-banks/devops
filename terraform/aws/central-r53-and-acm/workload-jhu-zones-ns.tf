resource "aws_route53_zone" "workload_jhu_prd" {
  provider = aws.workload_jhu_prd

  name = "${var.r53_delegate.workload_jhu}.${aws_route53_zone.aws_prd.name}"
}

resource "aws_route53_record" "workload_jhu_ns_prd" {
  provider = aws.this

  zone_id = aws_route53_zone.aws_prd.zone_id
  name    = aws_route53_zone.workload_jhu_prd.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.workload_jhu_prd.name_servers
}

resource "aws_route53_zone" "workload_jhu_stg" {
  provider = aws.workload_jhu_stg

  name = "${var.r53_delegate.workload_jhu}-stg.${aws_route53_zone.aws_prd.name}"
}

resource "aws_route53_record" "workload_jhu_ns_stg" {
  provider = aws.this

  zone_id = aws_route53_zone.aws_prd.zone_id
  name    = aws_route53_zone.workload_jhu_stg.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.workload_jhu_stg.name_servers
}

resource "aws_route53_zone" "workload_jhu_tst" {
  provider = aws.workload_jhu_tst

  name = "${var.r53_delegate.workload_jhu}-tst.${aws_route53_zone.aws_prd.name}"
}

resource "aws_route53_record" "workload_jhu_ns_tst" {
  provider = aws.this

  zone_id = aws_route53_zone.aws_prd.zone_id
  name    = aws_route53_zone.workload_jhu_tst.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.workload_jhu_tst.name_servers
}

resource "aws_route53_zone" "workload_jhu_dev" {
  provider = aws.workload_jhu_dev

  name = "${var.r53_delegate.workload_jhu}-dev.${aws_route53_zone.aws_prd.name}"
}

resource "aws_route53_record" "workload_jhu_ns_dev" {
  provider = aws.this

  zone_id = aws_route53_zone.aws_prd.zone_id
  name    = aws_route53_zone.workload_jhu_dev.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.workload_jhu_dev.name_servers
}