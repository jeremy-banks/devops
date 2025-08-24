resource "aws_route53_zone" "cockydevops_com_central" {
  provider = aws.network_prd

  name = "cockydevops.com"
}

resource "aws_route53_zone" "cockydevops_com_prd" {
  provider = aws.network_prd

  name = "prd.${aws_route53_zone.cockydevops_com_central.name}"
}

resource "aws_route53_zone" "cockydevops_com_stg" {
  provider = aws.network_prd

  name = "stg.${aws_route53_zone.cockydevops_com_central.name}"
}

resource "aws_route53_zone" "cockydevops_com_tst" {
  provider = aws.network_prd

  name = "tst.${aws_route53_zone.cockydevops_com_central.name}"
}

resource "aws_route53_zone" "cockydevops_com_dev" {
  provider = aws.network_prd

  name = "dev.${aws_route53_zone.cockydevops_com_central.name}"
}