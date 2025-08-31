resource "aws_route53_zone" "central_root" {
  provider = aws.this

  name = local.central_zone_root
}