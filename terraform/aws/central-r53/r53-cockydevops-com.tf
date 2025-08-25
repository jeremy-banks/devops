resource "aws_route53_zone" "cockydevops_com_central" {
  provider = aws.network_prd

  name = "cockydevops.com"
}

resource "aws_route53_zone" "cockydevops_com_prd" {
  provider = aws.network_prd

  name = "prd.${aws_route53_zone.cockydevops_com_central.name}"
}

resource "aws_route53_record" "prd_ns" {
  provider = aws.network_prd

  zone_id  = aws_route53_zone.cockydevops_com_central.zone_id
  name     = aws_route53_zone.cockydevops_com_prd.name
  type     = "NS"
  ttl      = 300
  records  = aws_route53_zone.cockydevops_com_prd.name_servers
}

resource "aws_route53_zone" "cockydevops_com_stg" {
  provider = aws.network_prd

  name = "stg.${aws_route53_zone.cockydevops_com_central.name}"
}

resource "aws_route53_record" "stg_ns" {
  provider = aws.network_prd

  zone_id  = aws_route53_zone.cockydevops_com_central.zone_id
  name     = aws_route53_zone.cockydevops_com_stg.name
  type     = "NS"
  ttl      = 300
  records  = aws_route53_zone.cockydevops_com_stg.name_servers
}

resource "aws_route53_zone" "cockydevops_com_tst" {
  provider = aws.network_prd

  name = "tst.${aws_route53_zone.cockydevops_com_central.name}"
}

resource "aws_route53_record" "tst_ns" {
  provider = aws.network_prd

  zone_id  = aws_route53_zone.cockydevops_com_central.zone_id
  name     = aws_route53_zone.cockydevops_com_tst.name
  type     = "NS"
  ttl      = 300
  records  = aws_route53_zone.cockydevops_com_tst.name_servers
}

resource "aws_route53_zone" "cockydevops_com_dev" {
  provider = aws.network_prd

  name = "dev.${aws_route53_zone.cockydevops_com_central.name}"
}

resource "aws_route53_record" "dev_ns" {
  provider = aws.network_prd

  zone_id  = aws_route53_zone.cockydevops_com_central.zone_id
  name     = aws_route53_zone.cockydevops_com_dev.name
  type     = "NS"
  ttl      = 300
  records  = aws_route53_zone.cockydevops_com_dev.name_servers
}