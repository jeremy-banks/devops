module "shared_services_acm_prd_primary" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.shared_services_prd }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

module "shared_services_acm_prd_failover" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.shared_services_prd_failover }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

module "shared_services_acm_stg_primary" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.shared_services_stg }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

module "shared_services_acm_stg_failover" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.shared_services_stg_failover }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

module "shared_services_acm_records" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.this }

  create_certificate          = false
  create_route53_records_only = true
  validation_method           = "DNS"

  zone_id = aws_route53_zone.central_root.zone_id

  distinct_domain_names = flatten([
    module.shared_services_acm_prd_primary.distinct_domain_names,
    module.shared_services_acm_prd_failover.distinct_domain_names,
    module.shared_services_acm_stg_primary.distinct_domain_names,
    module.shared_services_acm_stg_failover.distinct_domain_names,
  ])

  acm_certificate_domain_validation_options = flatten([
    module.shared_services_acm_prd_primary.acm_certificate_domain_validation_options,
    module.shared_services_acm_prd_failover.acm_certificate_domain_validation_options,
    module.shared_services_acm_stg_primary.acm_certificate_domain_validation_options,
    module.shared_services_acm_stg_failover.acm_certificate_domain_validation_options,
  ])
}