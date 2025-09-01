provider "aws" {
  alias   = "shared_services_prd"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.shared_services_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "shared_services_stg"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.shared_services_stg}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

# resource "aws_route53_zone" "central_aws_svc_prd" {
#   provider = aws.shared_services_prd

#   name = "${var.r53_delegate.shared_services}.aws.${local.central_zone_root}"
# }

# resource "aws_route53_record" "central_aws_svc_ns_prd" {
#   provider = aws.shared_services_prd

#   zone_id = aws_route53_zone.central_root.zone_id
#   name    = aws_route53_zone.central_aws_svc_prd.name
#   type    = "NS"
#   ttl     = 86400
#   records = aws_route53_zone.central_aws_svc_prd.name_servers
# }

# resource "aws_route53_record" "central_aws_svc_wildcard_prd" {
#   provider = aws.shared_services_prd

#   zone_id = aws_route53_zone.central_root.zone_id
#   name    = "*.${var.r53_delegate.shared_services}.aws.${local.central_zone_root}"
#   type    = "CNAME"
#   ttl     = 86400
#   records = [aws_route53_zone.central_aws_svc_prd.name]
# }

# resource "aws_route53_zone" "central_aws_svc_stg" {
#   provider = aws.shared_services_stg

#   name = "svcstg.aws.${local.central_zone_root}"
# }

# resource "aws_route53_record" "central_aws_svc_ns_stg" {
#   provider = aws.shared_services_stg

#   zone_id = aws_route53_zone.central_aws_svc_prd.zone_id
#   name    = aws_route53_zone.central_aws_svc_stg.name
#   type    = "NS"
#   ttl     = 86400
#   records = aws_route53_zone.central_aws_svc_stg.name_servers
# }

# resource "aws_route53_record" "central_aws_svc_wildcard_stg" {
#   provider = aws.shared_services_stg

#   zone_id = aws_route53_zone.central_root.zone_id
#   name    = "*.${var.r53_delegate.shared_services}stg.aws.${local.central_zone_root}"
#   type    = "CNAME"
#   ttl     = 86400
#   records = [aws_route53_zone.central_aws_svc_stg.name]
# }