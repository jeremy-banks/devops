module "sdlc_acm_prd_primary" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.sdlc_prd }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]


  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "sdlc_acm_prd_primary_arn" {
  value = module.sdlc_acm_prd_primary.acm_certificate_arn
}

module "sdlc_acm_prd_failover" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.sdlc_prd_failover }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]


  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "sdlc_acm_prd_failover_arn" {
  value = module.sdlc_acm_prd_failover.acm_certificate_arn
}

module "sdlc_acm_stg_primary" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.sdlc_stg }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]


  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "sdlc_acm_stg_primary_arn" {
  value = module.sdlc_acm_stg_primary.acm_certificate_arn
}

module "sdlc_acm_stg_failover" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.sdlc_stg_failover }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "sdlc_acm_stg_failover_arn" {
  value = module.sdlc_acm_stg_failover.acm_certificate_arn
}

module "sdlc_acm_tst_primary" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.sdlc_tst }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "sdlc_acm_tst_primary_arn" {
  value = module.sdlc_acm_tst_primary.acm_certificate_arn
}

module "sdlc_acm_tst_failover" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.sdlc_tst_failover }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "sdlc_acm_tst_failover_arn" {
  value = module.sdlc_acm_tst_failover.acm_certificate_arn
}

module "sdlc_acm_dev_primary" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.sdlc_dev }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "sdlc_acm_dev_primary_arn" {
  value = module.sdlc_acm_dev_primary.acm_certificate_arn
}

module "sdlc_acm_dev_failover" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.sdlc_dev_failover }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "sdlc_acm_dev_failover_arn" {
  value = module.sdlc_acm_dev_failover.acm_certificate_arn
}

module "sdlc_acm_records" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.this }

  create_certificate          = false
  create_route53_records_only = true
  validation_method           = "DNS"

  zone_id = aws_route53_zone.central_root.zone_id

  distinct_domain_names = flatten([
    module.sdlc_acm_prd_primary.distinct_domain_names,
    module.sdlc_acm_prd_failover.distinct_domain_names,
    module.sdlc_acm_stg_primary.distinct_domain_names,
    module.sdlc_acm_stg_failover.distinct_domain_names,
    module.sdlc_acm_tst_primary.distinct_domain_names,
    module.sdlc_acm_tst_failover.distinct_domain_names,
    module.sdlc_acm_dev_primary.distinct_domain_names,
    module.sdlc_acm_dev_failover.distinct_domain_names,
  ])

  acm_certificate_domain_validation_options = flatten([
    module.sdlc_acm_prd_primary.acm_certificate_domain_validation_options,
    module.sdlc_acm_prd_failover.acm_certificate_domain_validation_options,
    module.sdlc_acm_stg_primary.acm_certificate_domain_validation_options,
    module.sdlc_acm_stg_failover.acm_certificate_domain_validation_options,
    module.sdlc_acm_tst_primary.acm_certificate_domain_validation_options,
    module.sdlc_acm_tst_failover.acm_certificate_domain_validation_options,
    module.sdlc_acm_dev_primary.acm_certificate_domain_validation_options,
    module.sdlc_acm_dev_failover.acm_certificate_domain_validation_options,
  ])
}