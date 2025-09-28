provider "aws" {
  alias   = "workload_wsu_prd"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.workload_wsu_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "workload_wsu_prd_failover"
  profile = var.cli_profile_name
  region  = var.region_failover.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.workload_wsu_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

module "workload_wsu_acm_prd_primary" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_wsu_prd }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]


  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "workload_wsu_acm_arn_prd_primary" { value = module.workload_wsu_acm_prd_primary.acm_certificate_arn }

module "workload_wsu_acm_prd_failover" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_wsu_prd_failover }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]


  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "workload_wsu_acm_arn_prd_failover" { value = module.workload_wsu_acm_prd_failover.acm_certificate_arn }

resource "aws_route53_zone" "workload_wsu_prd" {
  provider = aws.workload_wsu_prd

  name = "${var.r53_delegate.workload_wsu}.${aws_route53_zone.aws_prd.name}"
}

resource "aws_route53_record" "workload_wsu_ns_prd" {
  provider = aws.this

  zone_id = aws_route53_zone.aws_prd.zone_id
  name    = aws_route53_zone.workload_wsu_prd.name
  type    = "NS"
  ttl     = var.ttl.ns
  records = aws_route53_zone.workload_wsu_prd.name_servers
}

resource "aws_route53_record" "workload_wsu_www_prd" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "wsu.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = var.ttl.cname
  records = ["wsu.wsu.aws.${aws_route53_zone.central_root.name}"]
}

provider "aws" {
  alias   = "workload_wsu_stg"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.workload_wsu_stg}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "workload_wsu_stg_failover"
  profile = var.cli_profile_name
  region  = var.region_failover.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.workload_wsu_stg}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

module "workload_wsu_acm_stg_primary" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_wsu_stg }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]


  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "workload_wsu_acm_arn_stg_primary" { value = module.workload_wsu_acm_stg_primary.acm_certificate_arn }

module "workload_wsu_acm_stg_failover" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_wsu_stg_failover }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "workload_wsu_acm_arn_stg_failover" { value = module.workload_wsu_acm_stg_failover.acm_certificate_arn }

resource "aws_route53_zone" "workload_wsu_stg" {
  provider = aws.workload_wsu_stg

  name = "${var.r53_delegate.workload_wsu}-stg.${aws_route53_zone.aws_prd.name}"
}

resource "aws_route53_record" "workload_wsu_ns_stg" {
  provider = aws.this

  zone_id = aws_route53_zone.aws_prd.zone_id
  name    = aws_route53_zone.workload_wsu_stg.name
  type    = "NS"
  ttl     = var.ttl.ns
  records = aws_route53_zone.workload_wsu_stg.name_servers
}

resource "aws_route53_record" "workload_wsu_www_stg" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "wsu-stg.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = var.ttl.cname
  records = ["wsu.wsu-stg.aws.${aws_route53_zone.central_root.name}"]
}

provider "aws" {
  alias   = "workload_wsu_tst"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.workload_wsu_tst}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "workload_wsu_tst_failover"
  profile = var.cli_profile_name
  region  = var.region_failover.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.workload_wsu_tst}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

module "workload_wsu_acm_tst_primary" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_wsu_tst }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "workload_wsu_acm_arn_tst_primary" { value = module.workload_wsu_acm_tst_primary.acm_certificate_arn }

module "workload_wsu_acm_tst_failover" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_wsu_tst_failover }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "workload_wsu_acm_arn_tst_failover" { value = module.workload_wsu_acm_tst_failover.acm_certificate_arn }

resource "aws_route53_zone" "workload_wsu_tst" {
  provider = aws.workload_wsu_tst

  name = "${var.r53_delegate.workload_wsu}-tst.${aws_route53_zone.aws_prd.name}"
}

resource "aws_route53_record" "workload_wsu_ns_tst" {
  provider = aws.this

  zone_id = aws_route53_zone.aws_prd.zone_id
  name    = aws_route53_zone.workload_wsu_tst.name
  type    = "NS"
  ttl     = var.ttl.ns
  records = aws_route53_zone.workload_wsu_tst.name_servers
}

resource "aws_route53_record" "workload_wsu_www_tst" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "wsu-tst.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = var.ttl.cname
  records = ["wsu.wsu-tst.aws.${aws_route53_zone.central_root.name}"]
}

provider "aws" {
  alias   = "workload_wsu_dev"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.workload_wsu_dev}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "workload_wsu_dev_failover"
  profile = var.cli_profile_name
  region  = var.region_failover.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.workload_wsu_dev}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

module "workload_wsu_acm_dev_primary" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_wsu_dev }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "workload_wsu_acm_arn_dev_primary" { value = module.workload_wsu_acm_dev_primary.acm_certificate_arn }

module "workload_wsu_acm_dev_failover" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.workload_wsu_dev_failover }

  domain_name               = aws_route53_zone.central_root.name
  subject_alternative_names = ["*.${aws_route53_zone.central_root.name}"]

  create_route53_records = false
  validation_method      = "DNS"
  wait_for_validation    = false
}

output "workload_wsu_acm_arn_dev_failover" { value = module.workload_wsu_acm_dev_failover.acm_certificate_arn }

resource "aws_route53_zone" "workload_wsu_dev" {
  provider = aws.workload_wsu_dev

  name = "${var.r53_delegate.workload_wsu}-dev.${aws_route53_zone.aws_prd.name}"
}

resource "aws_route53_record" "workload_wsu_ns_dev" {
  provider = aws.this

  zone_id = aws_route53_zone.aws_prd.zone_id
  name    = aws_route53_zone.workload_wsu_dev.name
  type    = "NS"
  ttl     = var.ttl.ns
  records = aws_route53_zone.workload_wsu_dev.name_servers
}

resource "aws_route53_record" "workload_wsu_www_dev" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "wsu-dev.${aws_route53_zone.central_root.name}"
  type    = "CNAME"
  ttl     = var.ttl.cname
  records = ["wsu.wsu-dev.aws.${aws_route53_zone.central_root.name}"]
}

module "workload_wsu_acm_records" {
  source    = "terraform-aws-modules/acm/aws"
  version   = "~> 6.1.0"
  providers = { aws = aws.this }

  create_certificate          = false
  create_route53_records_only = true
  validation_method           = "DNS"

  zone_id = aws_route53_zone.central_root.zone_id

  distinct_domain_names = flatten([
    module.workload_wsu_acm_prd_primary.distinct_domain_names,
    module.workload_wsu_acm_prd_failover.distinct_domain_names,
    module.workload_wsu_acm_stg_primary.distinct_domain_names,
    module.workload_wsu_acm_stg_failover.distinct_domain_names,
    module.workload_wsu_acm_tst_primary.distinct_domain_names,
    module.workload_wsu_acm_tst_failover.distinct_domain_names,
    module.workload_wsu_acm_dev_primary.distinct_domain_names,
    module.workload_wsu_acm_dev_failover.distinct_domain_names,
  ])

  acm_certificate_domain_validation_options = flatten([
    module.workload_wsu_acm_prd_primary.acm_certificate_domain_validation_options,
    module.workload_wsu_acm_prd_failover.acm_certificate_domain_validation_options,
    module.workload_wsu_acm_stg_primary.acm_certificate_domain_validation_options,
    module.workload_wsu_acm_stg_failover.acm_certificate_domain_validation_options,
    module.workload_wsu_acm_tst_primary.acm_certificate_domain_validation_options,
    module.workload_wsu_acm_tst_failover.acm_certificate_domain_validation_options,
    module.workload_wsu_acm_dev_primary.acm_certificate_domain_validation_options,
    module.workload_wsu_acm_dev_failover.acm_certificate_domain_validation_options,
  ])
}