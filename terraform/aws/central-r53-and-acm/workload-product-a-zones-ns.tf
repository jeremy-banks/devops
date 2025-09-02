resource "aws_route53_zone" "central_aws_workload_product_a_prd" {
  provider = aws.workload_product_a_prd

  name = "${var.r53_delegate.workload_product_a}.${aws_route53_zone.central_aws_prd.name}"
}

resource "aws_route53_record" "central_aws_workload_product_a_ns_prd" {
  provider = aws.this

  zone_id = aws_route53_zone.central_aws_prd.zone_id
  name    = aws_route53_zone.central_aws_workload_product_a_prd.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_workload_product_a_prd.name_servers
}

resource "aws_route53_zone" "central_aws_workload_product_a_stg" {
  provider = aws.workload_product_a_stg

  name = "${var.r53_delegate.workload_product_a}stg.${aws_route53_zone.central_aws_prd.name}"
}

resource "aws_route53_record" "central_aws_workload_product_a_ns_stg" {
  provider = aws.this

  zone_id = aws_route53_zone.central_aws_prd.zone_id
  name    = aws_route53_zone.central_aws_workload_product_a_stg.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_workload_product_a_stg.name_servers
}

resource "aws_route53_zone" "central_aws_workload_product_a_tst" {
  provider = aws.workload_product_a_tst

  name = "${var.r53_delegate.workload_product_a}tst.${aws_route53_zone.central_aws_prd.name}"
}

resource "aws_route53_record" "central_aws_workload_product_a_ns_tst" {
  provider = aws.this

  zone_id = aws_route53_zone.central_aws_prd.zone_id
  name    = aws_route53_zone.central_aws_workload_product_a_tst.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_workload_product_a_tst.name_servers
}

resource "aws_route53_zone" "central_aws_workload_product_a_dev" {
  provider = aws.workload_product_a_dev

  name = "${var.r53_delegate.workload_product_a}dev.${aws_route53_zone.central_aws_prd.name}"
}

resource "aws_route53_record" "central_aws_workload_product_a_ns_dev" {
  provider = aws.this

  zone_id = aws_route53_zone.central_aws_prd.zone_id
  name    = aws_route53_zone.central_aws_workload_product_a_dev.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_workload_product_a_dev.name_servers
}