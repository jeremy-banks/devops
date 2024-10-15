# module "acm_wildcard_cert_primary" {
#   source  = "terraform-aws-modules/acm/aws"
#   version = "5.1.0"
#   providers = { aws = aws.sdlc_prd }

#   domain_name = var.company_domain
#   subject_alternative_names = ["*.${var.company_domain}"]

#   create_route53_records  = false
#   validation_method       = "DNS"
#   validation_record_fqdns = module.acm_dns_records_primary.validation_route53_record_fqdns
# }

# data "aws_route53_zone" "company_domain" {
#   provider = aws.network

#   name         = "${var.company_domain}"
#   private_zone = false
# }

# module "acm_dns_records_primary" {
#   source  = "terraform-aws-modules/acm/aws"
#   version = "5.1.0"
#   providers = { aws = aws.network }

#   create_certificate          = false
#   create_route53_records_only = true
#   validation_method           = "DNS"

#   zone_id               = data.aws_route53_zone.company_domain.zone_id
#   distinct_domain_names = module.acm_wildcard_cert_primary.distinct_domain_names

#   acm_certificate_domain_validation_options = module.acm_wildcard_cert_primary.acm_certificate_domain_validation_options
# }

# module "acm_wildcard_cert_failover" {
#   source  = "terraform-aws-modules/acm/aws"
#   version = "5.1.0"
#   providers = { aws = aws.sdlc_prd_failover }

#   domain_name = var.company_domain
#   subject_alternative_names = ["*.${var.company_domain}"]

#   create_route53_records  = false
#   validation_method       = "DNS"
#   validation_record_fqdns = module.acm_dns_records_primary.validation_route53_record_fqdns
# }

# module "acm_dns_records_failover" {
#   source  = "terraform-aws-modules/acm/aws"
#   version = "5.1.0"
#   providers = { aws = aws.network_failover }

#   create_certificate          = false
#   create_route53_records_only = true
#   validation_method           = "DNS"

#   zone_id               = data.aws_route53_zone.company_domain.zone_id
#   distinct_domain_names = module.acm_wildcard_cert_failover.distinct_domain_names

#   acm_certificate_domain_validation_options = module.acm_wildcard_cert_failover.acm_certificate_domain_validation_options
# }
