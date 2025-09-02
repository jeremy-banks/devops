resource "aws_route53_record" "artifactory_to_svc" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "artifactory.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["artifactory.svc.aws.${aws_route53_zone.central_root.name}"]
}

resource "aws_route53_record" "gitlab_to_svc" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "gitlab.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["gitlab.svc.aws.${aws_route53_zone.central_root.name}"]
}