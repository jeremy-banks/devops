module "acm_wildcard_cert_primary" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.1.1"
  providers = { aws = aws.sdlc_prd }

  create_certificate      = true
  create_route53_records  = false

  domain_name = local.acm_san_names[0]

  subject_alternative_names = slice(local.acm_san_names, 1, length(local.acm_san_names))

  validation_method   = "DNS"
  wait_for_validation = var.deployment_environment == "prd" ? false : true
}

data "aws_route53_zone" "public_zones" {
  provider = aws.sdlc_prd
  depends_on = [module.r53_zones]

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
  dns_ttl                     = 86400

  zone_id = data.aws_route53_zone.public_zones[each.key].zone_id
  distinct_domain_names = module.acm_wildcard_cert_primary.distinct_domain_names
  acm_certificate_domain_validation_options = module.acm_wildcard_cert_primary.acm_certificate_domain_validation_options
}

module "acm_wildcard_cert_failover" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.1.1"
  providers = { aws = aws.sdlc_prd_failover }

  create_certificate      = true
  create_route53_records  = false

  domain_name = local.acm_san_names[0]

  subject_alternative_names = slice(local.acm_san_names, 1, length(local.acm_san_names))

  validation_method   = "DNS"
  wait_for_validation = var.deployment_environment == "prd" ? false : true
}