provider "aws" {
  alias   = "workload_product_a_prd"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.workload_product_a_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "workload_product_a_stg"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.workload_product_a_stg}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "workload_product_a_tst"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.workload_product_a_tst}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "workload_product_a_dev"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.workload_product_a_dev}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

# resource "aws_route53_zone" "central_aws_workload_product_a_prd" {
#   provider = aws.workload_product_a_prd

#   name = "${var.r53_delegate.workload_product_a}.aws.${local.central_zone_root}"
# }

# resource "aws_route53_record" "central_aws_workload_product_a_ns_prd" {
#   provider = aws.workload_product_a_prd

#   zone_id = aws_route53_zone.central_root.zone_id
#   name    = aws_route53_zone.central_aws_workload_product_a_prd.name
#   type    = "NS"
#   ttl     = 86400
#   records = aws_route53_zone.central_aws_workload_product_a_prd.name_servers
# }

# resource "aws_route53_record" "central_aws_workload_product_a_wildcard_prd" {
#   provider = aws.workload_product_a_prd

#   zone_id = aws_route53_zone.central_root.zone_id
#   name    = "*.${var.r53_delegate.workload_product_a}.aws.${local.central_zone_root}"
#   type    = "CNAME"
#   ttl     = 86400
#   records = [aws_route53_zone.central_aws_workload_product_a_prd.name]
# }

# resource "aws_route53_zone" "central_aws_workload_product_a_stg" {
#   provider = aws.workload_product_a_stg

#   name = "pastg.aws.${local.central_zone_root}"
# }

# resource "aws_route53_record" "central_aws_workload_product_a_ns_stg" {
#   provider = aws.workload_product_a_stg

#   zone_id = aws_route53_zone.central_aws_workload_product_a_prd.zone_id
#   name    = aws_route53_zone.central_aws_workload_product_a_stg.name
#   type    = "NS"
#   ttl     = 86400
#   records = aws_route53_zone.central_aws_workload_product_a_stg.name_servers
# }

# resource "aws_route53_record" "central_aws_workload_product_a_wildcard_stg" {
#   provider = aws.workload_product_a_stg

#   zone_id = aws_route53_zone.central_root.zone_id
#   name    = "*.${var.r53_delegate.workload_product_a}stg.aws.${local.central_zone_root}"
#   type    = "CNAME"
#   ttl     = 86400
#   records = [aws_route53_zone.central_aws_workload_product_a_stg.name]
# }

# resource "aws_route53_zone" "central_aws_workload_product_a_tst" {
#   provider = aws.workload_product_a_tst

#   name = "patst.aws.${local.central_zone_root}"
# }

# resource "aws_route53_record" "central_aws_workload_product_a_ns_tst" {
#   provider = aws.workload_product_a_tst

#   zone_id = aws_route53_zone.central_aws_workload_product_a_prd.zone_id
#   name    = aws_route53_zone.central_aws_workload_product_a_tst.name
#   type    = "NS"
#   ttl     = 86400
#   records = aws_route53_zone.central_aws_workload_product_a_tst.name_servers
# }

# resource "aws_route53_record" "central_aws_workload_product_a_wildcard_tst" {
#   provider = aws.workload_product_a_tst

#   zone_id = aws_route53_zone.central_root.zone_id
#   name    = "*.${var.r53_delegate.workload_product_a}tst.aws.${local.central_zone_root}"
#   type    = "CNAME"
#   ttl     = 86400
#   records = [aws_route53_zone.central_aws_workload_product_a_tst.name]
# }

# resource "aws_route53_zone" "central_aws_workload_product_a_dev" {
#   provider = aws.workload_product_a_dev

#   name = "padev.aws.${local.central_zone_root}"
# }

# resource "aws_route53_record" "central_aws_workload_product_a_ns_dev" {
#   provider = aws.workload_product_a_dev

#   zone_id = aws_route53_zone.central_aws_workload_product_a_prd.zone_id
#   name    = aws_route53_zone.central_aws_workload_product_a_dev.name
#   type    = "NS"
#   ttl     = 86400
#   records = aws_route53_zone.central_aws_workload_product_a_dev.name_servers
# }

# resource "aws_route53_record" "central_aws_workload_product_a_wildcard_dev" {
#   provider = aws.workload_product_a_dev

#   zone_id = aws_route53_zone.central_root.zone_id
#   name    = "*.${var.r53_delegate.workload_product_a}dev.aws.${local.central_zone_root}"
#   type    = "CNAME"
#   ttl     = 86400
#   records = [aws_route53_zone.central_aws_workload_product_a_dev.name]
# }