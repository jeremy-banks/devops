module "workload_product_a_acm_prd_primary" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_product_a_prd }

  domain_name = aws_route53_zone.central_root.name
  subject_alternative_names = [
    "*.${aws_route53_zone.central_root.name}",
    "${aws_route53_zone.central_aws_workload_product_a_prd.name}",
    "*.${aws_route53_zone.central_aws_workload_product_a_prd.name}",
  ]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

module "workload_product_a_acm_prd_failover" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_product_a_prd_failover }

  domain_name = aws_route53_zone.central_root.name
  subject_alternative_names = [
    "*.${aws_route53_zone.central_root.name}",
    "${aws_route53_zone.central_aws_workload_product_a_prd.name}",
    "*.${aws_route53_zone.central_aws_workload_product_a_prd.name}",
  ]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

module "workload_product_a_acm_stg_primary" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_product_a_stg }

  domain_name = aws_route53_zone.central_root.name
  subject_alternative_names = [
    "*.${aws_route53_zone.central_root.name}",
    "${aws_route53_zone.central_aws_workload_product_a_stg.name}",
    "*.${aws_route53_zone.central_aws_workload_product_a_stg.name}",
  ]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

module "workload_product_a_acm_stg_failover" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_product_a_stg_failover }

  domain_name = aws_route53_zone.central_root.name
  subject_alternative_names = [
    "*.${aws_route53_zone.central_root.name}",
    "${aws_route53_zone.central_aws_workload_product_a_stg.name}",
    "*.${aws_route53_zone.central_aws_workload_product_a_stg.name}",
  ]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

module "workload_product_a_acm_tst_primary" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_product_a_tst }

  domain_name = aws_route53_zone.central_root.name
  subject_alternative_names = [
    "*.${aws_route53_zone.central_root.name}",
    "${aws_route53_zone.central_aws_workload_product_a_tst.name}",
    "*.${aws_route53_zone.central_aws_workload_product_a_tst.name}",
  ]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

module "workload_product_a_acm_tst_failover" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_product_a_tst_failover }

  domain_name = aws_route53_zone.central_root.name
  subject_alternative_names = [
    "*.${aws_route53_zone.central_root.name}",
    "${aws_route53_zone.central_aws_workload_product_a_tst.name}",
    "*.${aws_route53_zone.central_aws_workload_product_a_tst.name}",
  ]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

module "workload_product_a_acm_dev_primary" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_product_a_dev }

  domain_name = aws_route53_zone.central_root.name
  subject_alternative_names = [
    "*.${aws_route53_zone.central_root.name}",
    "${aws_route53_zone.central_aws_workload_product_a_dev.name}",
    "*.${aws_route53_zone.central_aws_workload_product_a_dev.name}",
  ]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

module "workload_product_a_acm_dev_failover" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_product_a_dev_failover }

  domain_name = aws_route53_zone.central_root.name
  subject_alternative_names = [
    "*.${aws_route53_zone.central_root.name}",
    "${aws_route53_zone.central_aws_workload_product_a_dev.name}",
    "*.${aws_route53_zone.central_aws_workload_product_a_dev.name}",
  ]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

module "workload_product_a_acm_records" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.this }

  create_certificate          = false
  create_route53_records_only = true
  validation_method           = "DNS"

  zone_id = aws_route53_zone.central_root.zone_id

  distinct_domain_names = distinct(flatten([
    module.workload_product_a_acm_prd_primary.distinct_domain_names,
    module.workload_product_a_acm_prd_failover.distinct_domain_names,
    module.workload_product_a_acm_stg_primary.distinct_domain_names,
    module.workload_product_a_acm_stg_failover.distinct_domain_names,
    module.workload_product_a_acm_tst_primary.distinct_domain_names,
    module.workload_product_a_acm_tst_failover.distinct_domain_names,
    module.workload_product_a_acm_dev_primary.distinct_domain_names,
    module.workload_product_a_acm_dev_failover.distinct_domain_names,
  ]))

  acm_certificate_domain_validation_options = distinct(flatten([
    module.workload_product_a_acm_prd_primary.acm_certificate_domain_validation_options,
    module.workload_product_a_acm_prd_failover.acm_certificate_domain_validation_options,
    module.workload_product_a_acm_stg_primary.acm_certificate_domain_validation_options,
    module.workload_product_a_acm_stg_failover.acm_certificate_domain_validation_options,
    module.workload_product_a_acm_tst_primary.acm_certificate_domain_validation_options,
    module.workload_product_a_acm_tst_failover.acm_certificate_domain_validation_options,
    module.workload_product_a_acm_dev_primary.acm_certificate_domain_validation_options,
    module.workload_product_a_acm_dev_failover.acm_certificate_domain_validation_options,
  ]))
}