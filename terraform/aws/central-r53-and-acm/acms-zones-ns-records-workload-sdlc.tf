provider "aws" {
  alias   = "workload_sdlc_prd"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.workload_sdlc_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "workload_sdlc_prd_failover"
  profile = var.cli_profile_name
  region  = var.region_failover.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.workload_sdlc_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

module "workload_sdlc_acm_prd_primary" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_sdlc_prd }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]


  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "workload_sdlc_acm_arn_prd_primary" { value = module.workload_sdlc_acm_prd_primary.acm_certificate_arn }

module "workload_sdlc_acm_prd_failover" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_sdlc_prd_failover }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]


  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "workload_sdlc_acm_arn_prd_failover" { value = module.workload_sdlc_acm_prd_failover.acm_certificate_arn }

resource "aws_route53_zone" "workload_sdlc_prd" {
  provider = aws.workload_sdlc_prd

  name = "${var.r53_delegate.workload_sdlc}.${aws_route53_zone.aws_prd.name}"
}

resource "aws_route53_record" "workload_sdlc_ns_prd" {
  provider = aws.this

  zone_id = aws_route53_zone.aws_prd.zone_id
  name    = aws_route53_zone.workload_sdlc_prd.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.workload_sdlc_prd.name_servers
}

resource "aws_route53_record" "workload_sdlc_www_prd" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "www.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["www.sdlc.aws.${aws_route53_zone.central_root.name}"]
}

provider "aws" {
  alias   = "workload_sdlc_stg"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.workload_sdlc_stg}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "workload_sdlc_stg_failover"
  profile = var.cli_profile_name
  region  = var.region_failover.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.workload_sdlc_stg}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

module "workload_sdlc_acm_stg_primary" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_sdlc_stg }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]


  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "workload_sdlc_acm_arn_stg_primary" { value = module.workload_sdlc_acm_stg_primary.acm_certificate_arn }

module "workload_sdlc_acm_stg_failover" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_sdlc_stg_failover }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "workload_sdlc_acm_arn_stg_failover" { value = module.workload_sdlc_acm_stg_failover.acm_certificate_arn }

resource "aws_route53_zone" "workload_sdlc_stg" {
  provider = aws.workload_sdlc_stg

  name = "${var.r53_delegate.workload_sdlc}-stg.${aws_route53_zone.aws_prd.name}"
}

resource "aws_route53_record" "workload_sdlc_ns_stg" {
  provider = aws.this

  zone_id = aws_route53_zone.aws_prd.zone_id
  name    = aws_route53_zone.workload_sdlc_stg.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.workload_sdlc_stg.name_servers
}

resource "aws_route53_record" "workload_sdlc_www_stg" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "www-stg.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["www.sdlc-stg.aws.${aws_route53_zone.central_root.name}"]
}

provider "aws" {
  alias   = "workload_sdlc_tst"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.workload_sdlc_tst}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "workload_sdlc_tst_failover"
  profile = var.cli_profile_name
  region  = var.region_failover.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.workload_sdlc_tst}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

module "workload_sdlc_acm_tst_primary" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_sdlc_tst }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "workload_sdlc_acm_arn_tst_primary" { value = module.workload_sdlc_acm_tst_primary.acm_certificate_arn }

module "workload_sdlc_acm_tst_failover" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_sdlc_tst_failover }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "workload_sdlc_acm_arn_tst_failover" { value = module.workload_sdlc_acm_tst_failover.acm_certificate_arn }

resource "aws_route53_zone" "workload_sdlc_tst" {
  provider = aws.workload_sdlc_tst

  name = "${var.r53_delegate.workload_sdlc}-tst.${aws_route53_zone.aws_prd.name}"
}

resource "aws_route53_record" "workload_sdlc_ns_tst" {
  provider = aws.this

  zone_id = aws_route53_zone.aws_prd.zone_id
  name    = aws_route53_zone.workload_sdlc_tst.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.workload_sdlc_tst.name_servers
}

resource "aws_route53_record" "workload_sdlc_www_tst" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "www-tst.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["www.sdlc-tst.aws.${aws_route53_zone.central_root.name}"]
}

provider "aws" {
  alias   = "workload_sdlc_dev"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.workload_sdlc_dev}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "workload_sdlc_dev_failover"
  profile = var.cli_profile_name
  region  = var.region_failover.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.workload_sdlc_dev}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

module "workload_sdlc_acm_dev_primary" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_sdlc_dev }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "workload_sdlc_acm_arn_dev_primary" { value = module.workload_sdlc_acm_dev_primary.acm_certificate_arn }

module "workload_sdlc_acm_dev_failover" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_sdlc_dev_failover }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "workload_sdlc_acm_arn_dev_failover" { value = module.workload_sdlc_acm_dev_failover.acm_certificate_arn }

resource "aws_route53_zone" "workload_sdlc_dev" {
  provider = aws.workload_sdlc_dev

  name = "${var.r53_delegate.workload_sdlc}-dev.${aws_route53_zone.aws_prd.name}"
}

resource "aws_route53_record" "workload_sdlc_ns_dev" {
  provider = aws.this

  zone_id = aws_route53_zone.aws_prd.zone_id
  name    = aws_route53_zone.workload_sdlc_dev.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.workload_sdlc_dev.name_servers
}

resource "aws_route53_record" "workload_sdlc_www_dev" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "www-dev.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = 300
  records = ["www.sdlc-dev.aws.${aws_route53_zone.central_root.name}"]
}

module "workload_sdlc_acm_records" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.this }

  create_certificate          = false
  create_route53_records_only = true
  validation_method           = "DNS"

  zone_id = aws_route53_zone.central_root.zone_id

  distinct_domain_names = flatten([
    module.workload_sdlc_acm_prd_primary.distinct_domain_names,
    module.workload_sdlc_acm_prd_failover.distinct_domain_names,
    module.workload_sdlc_acm_stg_primary.distinct_domain_names,
    module.workload_sdlc_acm_stg_failover.distinct_domain_names,
    module.workload_sdlc_acm_tst_primary.distinct_domain_names,
    module.workload_sdlc_acm_tst_failover.distinct_domain_names,
    module.workload_sdlc_acm_dev_primary.distinct_domain_names,
    module.workload_sdlc_acm_dev_failover.distinct_domain_names,
  ])

  acm_certificate_domain_validation_options = flatten([
    module.workload_sdlc_acm_prd_primary.acm_certificate_domain_validation_options,
    module.workload_sdlc_acm_prd_failover.acm_certificate_domain_validation_options,
    module.workload_sdlc_acm_stg_primary.acm_certificate_domain_validation_options,
    module.workload_sdlc_acm_stg_failover.acm_certificate_domain_validation_options,
    module.workload_sdlc_acm_tst_primary.acm_certificate_domain_validation_options,
    module.workload_sdlc_acm_tst_failover.acm_certificate_domain_validation_options,
    module.workload_sdlc_acm_dev_primary.acm_certificate_domain_validation_options,
    module.workload_sdlc_acm_dev_failover.acm_certificate_domain_validation_options,
  ])
}