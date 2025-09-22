resource "aws_route53_record" "workload_jhu_prd_jhu" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "jhu.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["jhu.jhu.aws.${aws_route53_zone.central_root.name}"]
}

resource "aws_route53_record" "workload_jhu_stg_jhu" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "jhu-stg.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["jhu.jhu-stg.aws.${aws_route53_zone.central_root.name}"]
}

resource "aws_route53_record" "workload_jhu_tst_jhu" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "jhu-tst.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["jhu.jhu-tst.aws.${aws_route53_zone.central_root.name}"]
}

resource "aws_route53_record" "workload_jhu_dev_jhu" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "jhu-dev.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["jhu.jhu-dev.aws.${aws_route53_zone.central_root.name}"]
}