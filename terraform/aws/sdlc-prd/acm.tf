module "acm_wildcard_cert_primary" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.1.1"
  providers = { aws = aws.sdlc_prd }

  for_each = toset(var.r53_zones)

  create_certificate      = true
  create_route53_records  = false

  domain_name = var.deployment_environment == "prd" ? "*.${element(var.r53_zones, 0)}" : "*.${var.deployment_environment}.${element(var.r53_zones, 0)}"

  subject_alternative_names = flatten([
    var.deployment_environment == "prd" ? ["${element(var.r53_zones, 0)}"] : ["${var.deployment_environment}.${element(var.r53_zones, 0)}"],
    [for zone in var.r53_zones : var.deployment_environment == "prd" ? "*.${zone}" : "*.${var.deployment_environment}.${zone}"],
    [for zone in var.r53_zones : var.deployment_environment == "prd" ? "${zone}" : "${var.deployment_environment}.${zone}"]
  ])

  validation_method   = "DNS"
  wait_for_validation = false
}

resource "aws_route53_record" "acm_validation" {
  provider = aws.sdlc_prd

  for_each = { for zone, cert in module.acm_wildcard_cert_primary : zone => cert if cert.acm_certificate_domain_validation_options != [] }

  name    = each.value.acm_certificate_domain_validation_options[0].resource_record_name
  type    = each.value.acm_certificate_domain_validation_options[0].resource_record_type
  records = [each.value.acm_certificate_domain_validation_options[0].resource_record_value]
  
  # Correctly reference the zone ID
  zone_id = module.r53_zones.route53_zone_zone_id[each.key]

  ttl = 86400

  allow_overwrite = true
}

# module "acm_dns_records_primary" {
#   source  = "terraform-aws-modules/acm/aws"
#   version = "5.1.1"
#   providers = { aws = aws.sdlc_prd }

#   for_each = toset(var.r53_zones)

#   create_certificate          = false
#   create_route53_records_only = true
#   validation_method           = "DNS"

#   zone_id = module.r53_zones.route53_zone_zone_id[each.key]

#   # Use distinct domain names from the ACM module
#   distinct_domain_names = module.acm_wildcard_cert_primary[each.key].distinct_domain_names

#   dns_ttl = 86400

#   # Reference the validation options correctly
#   acm_certificate_domain_validation_options = [
#     for option in module.acm_wildcard_cert_primary[each.key].acm_certificate_domain_validation_options : {
#       resource_record_name = option.resource_record_name
#       resource_record_type = option.resource_record_type
#       resource_record_value = option.resource_record_value
#     }
#   ]
# }

module "acm_wildcard_cert_failover" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.1.1"
  providers = { aws = aws.sdlc_prd_failover }

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

  zone_id               = module.r53_zones.route53_zone_zone_id[each.key]
  distinct_domain_names = module.acm_wildcard_cert_failover[each.key].distinct_domain_names

  dns_ttl = 86400

  acm_certificate_domain_validation_options = module.acm_wildcard_cert_failover[each.key].acm_certificate_domain_validation_options
}