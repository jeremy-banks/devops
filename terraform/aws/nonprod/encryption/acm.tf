# resource "aws_acm_certificate" "example" {
#   domain_name       = "example.com"
#   validation_method = "DNS"

#   tags = {
#     Environment = "production"
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_route53_record" "example" {
#   name    = aws_acm_certificate.example.domain_validation_options[0].resource_record_name
#   type    = aws_acm_certificate.example.domain_validation_options[0].resource_record_type
#   zone_id = "<YOUR_ROUTE53_ZONE_ID>"
#   records = [aws_acm_certificate.example.domain_validation_options[0].resource_record_value]
#   ttl     = 60
# }

# resource "aws_acm_certificate_validation" "example" {
#   certificate_arn         = aws_acm_certificate.example.arn
#   validation_record_fqdns = [aws_route53_record.example.fqdn]
# }