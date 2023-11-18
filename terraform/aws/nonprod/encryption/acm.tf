module "acm_wildcard_cert" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.0.0"

  domain_name = local.domain_name
  subject_alternative_names = ["*.${local.domain_name}"]

  create_route53_records  = false
  validation_method       = "DNS"
  validation_record_fqdns = module.acm_dns_records.validation_route53_record_fqdns
}

data "aws_route53_zone" "selected" {
  name         = "${local.domain_name}."
  private_zone = false

  providers = { aws = aws.r53 }
}

module "acm_dns_records" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.0.0"

  providers = { aws = aws.r53 }

  create_certificate          = false
  create_route53_records_only = true
  validation_method           = "DNS"

  zone_id               = local.zone_id
  distinct_domain_names = module.acm_wildcard_cert.distinct_domain_names

  acm_certificate_domain_validation_options = module.acm_wildcard_cert.acm_certificate_domain_validation_options
}