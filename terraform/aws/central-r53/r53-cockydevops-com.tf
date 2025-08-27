locals {
  cockydevops_com_prd = "cockydevops.com"
}

resource "aws_route53_zone" "cockydevops_com_prd" {
  provider = aws.network_prd

  name = local.cockydevops_com_prd
}

resource "aws_ram_resource_share" "cockydevops_com_prd" {
  provider = aws.network_prd

  name                      = local.cockydevops_com_prd
  allow_external_principals = false
}

# resource "aws_route53profiles_profile" "cockydevops_com_prd" {
#   provider = aws.network_prd

#   name = local.cockydevops_com_prd
# }

# resource "aws_route53profiles_resource_association" "cockydevops_com_prd" {
#   provider = aws.network_prd

#   name         = local.cockydevops_com_prd
#   profile_id   = aws_route53profiles_profile.cockydevops_com_prd.id
#   resource_arn = aws_route53_zone.cockydevops_com_prd.arn
# }

# resource "aws_ram_resource_association" "cockydevops_com_prd_workload" {
#   provider = aws.network_prd

#   resource_arn       = aws_route53_zone.cockydevops_com_prd.arn
#   resource_share_arn = aws_ram_resource_share.cockydevops_com_prd.arn
# }

resource "aws_route53_zone" "cockydevops_com_stg" {
  provider = aws.workload_product_a_stg

  name = "stg.${aws_route53_zone.cockydevops_com_prd.name}"
}

resource "aws_route53_record" "cockydevops_com_stg_ns" {
  provider = aws.network_prd

  zone_id = aws_route53_zone.cockydevops_com_prd.zone_id
  name    = aws_route53_zone.cockydevops_com_stg.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.cockydevops_com_stg.name_servers
}

resource "aws_route53_zone" "cockydevops_com_tst" {
  provider = aws.workload_product_a_tst

  name = "tst.${aws_route53_zone.cockydevops_com_prd.name}"
}

resource "aws_route53_record" "cockydevops_com_tst_ns" {
  provider = aws.network_prd

  zone_id = aws_route53_zone.cockydevops_com_prd.zone_id
  name    = aws_route53_zone.cockydevops_com_tst.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.cockydevops_com_tst.name_servers
}

resource "aws_route53_zone" "cockydevops_com_dev" {
  provider = aws.workload_product_a_dev

  name = "dev.${aws_route53_zone.cockydevops_com_prd.name}"
}

resource "aws_route53_record" "cockydevops_com_dev_ns" {
  provider = aws.network_prd

  zone_id = aws_route53_zone.cockydevops_com_prd.zone_id
  name    = aws_route53_zone.cockydevops_com_dev.name
  type    = "NS"
  ttl     = 86400
  records = aws_route53_zone.cockydevops_com_dev.name_servers
}