resource "aws_route53_record" "shared_services_prd_artifactory" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "artifactory.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["artifactory.svc.aws.${aws_route53_zone.central_root.name}"]
}

resource "aws_route53_record" "shared_services_stg_artifactory" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "artifactory-stg.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["artifactory.svc-stg.aws.${aws_route53_zone.central_root.name}"]
}

resource "aws_route53_record" "shared_services_prd_gitlab" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "gitlab.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["gitlab.svc.aws.${aws_route53_zone.central_root.name}"]
}

resource "aws_route53_record" "shared_services_stg_gitlab" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "gitlab-stg.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["gitlab.svc-stg.aws.${aws_route53_zone.central_root.name}"]
}