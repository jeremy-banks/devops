#primary
data "aws_vpc" "network_primary" {
  provider = aws.network

  cidr_block = "${var.vpc_cidr_network.primary}"
  state = "available"
}

data "aws_subnets" "network_primary" {
  provider = aws.network

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.network_primary.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*-pvt-*"]
  }
}

resource "aws_directory_service_directory" "ad_primary" {
  provider = aws.identity

  name        = "corp.${var.company_domain}"
  short_name  = "CORP"
  alias       = "${var.company_name}-ad"
  password    = var.ad_directory_admin_password
  type        = "MicrosoftAD"
  edition     = "Enterprise"
  vpc_settings {
    vpc_id      = data.aws_vpc.network_primary.id
    subnet_ids  = slice(data.aws_subnets.network_primary.ids, 0, 2)
  }
}

data "aws_organizations_organization" "org" {
  provider = aws.identity
}

data "aws_route53_zone" "company_domain" {
  provider  = aws.network

  name  = "${var.company_domain}."
}

resource "aws_route53_record" "corp_ad" {
  provider  = aws.network

  zone_id = data.aws_route53_zone.company_domain.zone_id
  name    = "corp.${var.company_domain}"
  type    = "A"
  ttl     = 300
  records = concat(
    tolist(aws_directory_service_directory.ad_primary.dns_ip_addresses),
    tolist(data.aws_directory_service_directory.ad_failover.dns_ip_addresses)
  )
}

#failover
data "aws_vpc" "network_failover" {
  provider = aws.network_failover

  cidr_block = "${var.vpc_cidr_network.failover}"
  state = "available"
}

data "aws_subnets" "network_failover" {
  provider = aws.network_failover
  
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.network_failover.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*-pvt-*"]
  }
}

resource "aws_directory_service_region" "ad_failover" {
  provider = aws.identity

  directory_id = aws_directory_service_directory.ad_primary.id
  region_name  = var.region.failover

  vpc_settings {
    vpc_id     = data.aws_vpc.network_failover.id
    subnet_ids = slice(data.aws_subnets.network_failover.ids, 0, 2)
  }
}

data "aws_directory_service_directory" "ad_failover" {
  provider = aws.identity_failover

  directory_id = split(",", aws_directory_service_region.ad_failover.id)[0]
}