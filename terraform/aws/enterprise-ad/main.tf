#primary
data "aws_vpc" "shared_primary" {
  provider = aws.shared_services

  cidr_block = "${var.vpc_cidr_network_primary}"
  state = "available"
}

data "aws_subnets" "shared_primary" {
  provider = aws.shared_services

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.shared_primary.id]
  }

  filter {
    name   = "mapPublicIpOnLaunch"
    values = ["false"]
  }
}

resource "aws_directory_service_directory" "ad_primary" {
  provider = aws.shared_services

  name        = "corp.${var.company_domain}"
  short_name  = "CORP"
  alias       = "${var.company_name}-ad"
  password    = var.ad_directory_admin_password
  type        = "MicrosoftAD"
  edition     = "Enterprise"
  vpc_settings {
    vpc_id      = data.aws_vpc.shared_primary.id
    subnet_ids  = slice(data.aws_subnets.shared_primary.ids, 0, 2)
  }
}

data "aws_organizations_organization" "org" {
  provider = aws.shared_services
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
data "aws_vpc" "shared_failover" {
  provider = aws.shared_services_failover

  cidr_block = "${var.vpc_cidr_network_failover}"
  state = "available"
}

data "aws_subnets" "shared_failover" {
  provider = aws.shared_services_failover
  
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.shared_failover.id]
  }

  filter {
    name   = "mapPublicIpOnLaunch"
    values = ["false"]
  }
}

resource "aws_directory_service_region" "ad_failover" {
  provider = aws.shared_services

  directory_id = aws_directory_service_directory.ad_primary.id
  region_name  = var.region.failover

  vpc_settings {
    vpc_id     = data.aws_vpc.shared_failover.id
    subnet_ids = slice(data.aws_subnets.shared_failover.ids, 0, 2)
  }
}

data "aws_directory_service_directory" "ad_failover" {
  provider = aws.shared_services_failover

  directory_id = split(",", aws_directory_service_region.ad_failover.id)[0]
}