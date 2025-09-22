provider "aws" {
  alias   = "shared_services_prd"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.shared_services_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "shared_services_prd_failover"
  profile = var.cli_profile_name
  region  = var.region_failover.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.shared_services_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

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

output "shared_services_acm_arn_prd_primary" { value = module.shared_services_acm_prd_primary.acm_certificate_arn }

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

output "shared_services_acm_arn_prd_failover" { value = module.shared_services_acm_prd_failover.acm_certificate_arn }

resource "aws_route53_zone" "shared_services_prd" {
  provider = aws.shared_services_prd

  name = "${var.r53_delegate.shared_services}.${aws_route53_zone.aws_prd.name}"
}

resource "aws_route53_record" "shared_services_ns_prd" {
  provider = aws.this

  zone_id = aws_route53_zone.aws_prd.zone_id
  name    = aws_route53_zone.shared_services_prd.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.shared_services_prd.name_servers
}

resource "aws_route53_record" "shared_services_artifactory_prd" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "artifactory.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["artifactory.svc.aws.${aws_route53_zone.central_root.name}"]
}

resource "aws_route53_record" "shared_services_gitlab_prd" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "gitlab.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["gitlab.svc.aws.${aws_route53_zone.central_root.name}"]
}

provider "aws" {
  alias   = "shared_services_stg"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.shared_services_stg}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "shared_services_stg_failover"
  profile = var.cli_profile_name
  region  = var.region_failover.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.shared_services_stg}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
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

output "shared_services_acm_arn_stg_primary" { value = module.shared_services_acm_stg_primary.acm_certificate_arn }

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

output "shared_services_acm_arn_stg_failover" { value = module.shared_services_acm_stg_failover.acm_certificate_arn }

resource "aws_route53_zone" "shared_services_stg" {
  provider = aws.shared_services_stg

  name = "${var.r53_delegate.shared_services}-stg.${aws_route53_zone.aws_prd.name}"
}

resource "aws_route53_record" "shared_services_ns_stg" {
  provider = aws.this

  zone_id = aws_route53_zone.aws_prd.zone_id
  name    = aws_route53_zone.shared_services_stg.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.shared_services_stg.name_servers
}

resource "aws_route53_record" "shared_services_artifactory_stg" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "artifactory-stg.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["artifactory.svc-stg.aws.${aws_route53_zone.central_root.name}"]
}

resource "aws_route53_record" "shared_services_gitlab_stg" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "gitlab-stg.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["gitlab.svc-stg.aws.${aws_route53_zone.central_root.name}"]
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