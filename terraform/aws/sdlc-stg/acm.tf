module "acm_wildcard_cert_primary" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.1.1"
  providers = { aws = aws.sdlc_stg }

  for_each = toset(var.r53_zones)

  create_certificate      = true
  create_route53_records  = false

  domain_name               = var.deployment_environment == "prd" ? "*.${each.key}" : "*.${var.deployment_environment}.${each.key}"
  subject_alternative_names = var.deployment_environment == "prd" ? ["${each.key}"] : ["${var.deployment_environment}.${each.key}"]

  validation_method   = "DNS"
  wait_for_validation = false
}

data "aws_route53_zone" "public_zones" {
  provider = aws.sdlc_prd

  for_each = toset(var.r53_zones)

  name         = "${each.key}."
  private_zone = false
}

module "acm_dns_records_primary" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.1.1"
  providers = { aws = aws.sdlc_prd }

  for_each = toset(var.r53_zones)

  create_certificate          = false
  create_route53_records_only = true
  validation_method           = "DNS"

  zone_id               = data.aws_route53_zone.public_zones[each.key].zone_id
  distinct_domain_names = module.acm_wildcard_cert_primary[each.key].distinct_domain_names

  dns_ttl = 86400

  acm_certificate_domain_validation_options = module.acm_wildcard_cert_primary[each.key].acm_certificate_domain_validation_options
}

module "acm_wildcard_cert_failover" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.1.1"
  providers = { aws = aws.sdlc_stg_failover }

  for_each = toset(var.r53_zones)

  create_certificate      = true
  create_route53_records  = false

  domain_name               = var.deployment_environment == "prd" ? "*.${each.key}" : "*.${var.deployment_environment}.${each.key}"
  subject_alternative_names = var.deployment_environment == "prd" ? ["${each.key}"] : ["${var.deployment_environment}.${each.key}"]

  validation_method   = "DNS"
  wait_for_validation = false
}

module "acm_dns_records_failover" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.1.1"
  providers = { aws = aws.sdlc_prd_failover }

  for_each = toset(var.r53_zones)

  create_certificate          = false
  create_route53_records_only = true
  validation_method           = "DNS"

  zone_id               = data.aws_route53_zone.public_zones[each.key].zone_id
  distinct_domain_names = module.acm_wildcard_cert_failover[each.key].distinct_domain_names

  dns_ttl = 86400

  acm_certificate_domain_validation_options = module.acm_wildcard_cert_failover[each.key].acm_certificate_domain_validation_options
}