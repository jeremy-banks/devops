module "acm_wildcard_cert_primary" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.1.1"
  providers = { aws = aws.sdlc_prd }

  create_certificate      = true
  create_route53_records  = false

  domain_name = local.acm_san_names[0]

  subject_alternative_names = slice(local.acm_san_names, 1, length(local.acm_san_names))

  validation_method   = "DNS"
  wait_for_validation = false
}

module "acm_dns_records_primary" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.1.1"
  providers = { aws = aws.sdlc_prd }


  for_each = { for validation in module.acm_wildcard_cert_primary.validation_domains : validation.domain_name => validation }

  create_certificate          = false
  create_route53_records_only = true
  validation_method           = "DNS"
  dns_ttl                     = 86400

  zone_id = lookup(module.r53_zones.route53_zone_zone_id, each.value.domain_name, null)

  distinct_domain_names = [each.value.domain_name]
  acm_certificate_domain_validation_options = [
    {
      domain_name = each.value.domain_name
      resource_record_name = each.value.resource_record_name
      resource_record_type = each.value.resource_record_type
      resource_record_value = each.value.resource_record_value
    }
  ]
}

# module "acm_wildcard_cert_failover" {
#   source  = "terraform-aws-modules/acm/aws"
#   version = "5.1.1"
#   providers = { aws = aws.sdlc_prd_failover }

#   for_each = toset(var.r53_zones)

#   create_certificate      = true
#   create_route53_records  = false

#   domain_name               = var.deployment_environment == "prd" ? "*.${each.key}" : "*.${var.deployment_environment}.${each.key}"
#   subject_alternative_names = var.deployment_environment == "prd" ? ["${each.key}"] : ["${var.deployment_environment}.${each.key}"]

#   validation_method   = "DNS"
#   wait_for_validation = false
# }

# module "acm_dns_records_failover" {
#   source  = "terraform-aws-modules/acm/aws"
#   version = "5.1.1"
#   providers = { aws = aws.sdlc_prd_failover }

#   for_each = toset(var.r53_zones)

#   create_certificate          = false
#   create_route53_records_only = true
#   validation_method           = "DNS"

#   zone_id               = module.r53_zones.route53_zone_zone_id[each.key]
#   distinct_domain_names = module.acm_wildcard_cert_failover[each.key].distinct_domain_names

#   dns_ttl = 86400

#   acm_certificate_domain_validation_options = module.acm_wildcard_cert_failover[each.key].acm_certificate_domain_validation_options
# }