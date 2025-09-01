provider "aws" {
  alias   = "sdlc_prd"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.sdlc_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "sdlc_stg"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.sdlc_stg}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "sdlc_tst"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.sdlc_tst}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "sdlc_dev"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.sdlc_dev}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

resource "aws_route53_zone" "central_aws_sdlc_prd" {
  provider = aws.sdlc_prd

  name = "${var.r53_delegate.sdlc}.aws.${local.central_zone_root}"
}

resource "aws_route53_record" "central_aws_sdlc_ns_prd" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = aws_route53_zone.central_aws_sdlc_prd.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_sdlc_prd.name_servers
}

resource "aws_route53_record" "central_aws_sdlc_wildcard_prd" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "*.${var.r53_delegate.sdlc}.aws.${local.central_zone_root}"
  type    = "CNAME"
  ttl     = 86400
  records = [aws_route53_zone.central_aws_sdlc_prd.name]
}

resource "aws_route53_zone" "central_aws_sdlc_stg" {
  provider = aws.sdlc_stg

  name = "sdlcstg.aws.${local.central_zone_root}"
}

resource "aws_route53_record" "central_aws_sdlc_ns_stg" {
  provider = aws.sdlc_prd

  zone_id = aws_route53_zone.central_aws_sdlc_prd.zone_id
  name    = aws_route53_zone.central_aws_sdlc_stg.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_sdlc_stg.name_servers
}

resource "aws_route53_record" "central_aws_sdlc_wildcard_stg" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "*.${var.r53_delegate.sdlc}stg.aws.${local.central_zone_root}"
  type    = "CNAME"
  ttl     = 86400
  records = [aws_route53_zone.central_aws_sdlc_stg.name]
}

resource "aws_route53_zone" "central_aws_sdlc_tst" {
  provider = aws.sdlc_tst

  name = "sdlctst.aws.${local.central_zone_root}"
}

resource "aws_route53_record" "central_aws_sdlc_ns_tst" {
  provider = aws.sdlc_prd

  zone_id = aws_route53_zone.central_aws_sdlc_prd.zone_id
  name    = aws_route53_zone.central_aws_sdlc_tst.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_sdlc_tst.name_servers
}

resource "aws_route53_record" "central_aws_sdlc_wildcard_tst" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "*.${var.r53_delegate.sdlc}tst.aws.${local.central_zone_root}"
  type    = "CNAME"
  ttl     = 86400
  records = [aws_route53_zone.central_aws_sdlc_tst.name]
}

resource "aws_route53_zone" "central_aws_sdlc_dev" {
  provider = aws.sdlc_dev

  name = "sdlcdev.aws.${local.central_zone_root}"
}

resource "aws_route53_record" "central_aws_sdlc_ns_dev" {
  provider = aws.sdlc_prd

  zone_id = aws_route53_zone.central_aws_sdlc_prd.zone_id
  name    = aws_route53_zone.central_aws_sdlc_dev.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.central_aws_sdlc_dev.name_servers
}

resource "aws_route53_record" "central_aws_sdlc_wildcard_dev" {
  provider = aws.this

  zone_id = aws_route53_zone.central_root.zone_id
  name    = "*.${var.r53_delegate.sdlc}dev.aws.${local.central_zone_root}"
  type    = "CNAME"
  ttl     = 86400
  records = [aws_route53_zone.central_aws_sdlc_dev.name]
}