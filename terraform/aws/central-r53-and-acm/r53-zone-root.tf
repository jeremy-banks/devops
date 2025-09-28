resource "aws_route53_zone" "central_root" {
  provider = aws.this

  name = local.central_zone_root
}

output "central_root" { value = aws_route53_zone.central_root.name_servers }