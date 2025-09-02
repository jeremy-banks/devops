#api
#www

resource "aws_route53_record" "www_to_sdlc" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "www.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["www.sdlc.aws.${aws_route53_zone.central_root.name}"]
}