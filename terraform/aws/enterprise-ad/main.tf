#primary
data "aws_vpc" "shared_primary" {
  provider = aws.org

  cidr_block = "${var.vpc_prefixes.shared_vpc.primary}.0.0/16"
  state = "available"
}

data "aws_subnet" "shared_a_primary" {
  provider = aws.org

  cidr_block = "${var.vpc_prefixes.shared_vpc.primary}.${var.vpc_suffixes.subnet_private_a}"
  state = "available"
}

data "aws_subnet" "shared_b_primary" {
  provider = aws.org

  cidr_block = "${var.vpc_prefixes.shared_vpc.primary}.${var.vpc_suffixes.subnet_private_b}"
  state = "available"
}

resource "aws_directory_service_directory" "ad_primary" {
  provider = aws.org

  name        = "corp.${var.company_domain}"
  short_name  = "CORP"
  alias       = "${var.company_name}-ad"
  password    = "tempSuperSecretPassword123"
  type        = "MicrosoftAD"
  edition     = "Enterprise"
  vpc_settings {
    vpc_id      = data.aws_vpc.shared_primary.id
    subnet_ids  = [data.aws_subnet.shared_a_primary.id, data.aws_subnet.shared_b_primary.id]
  }
}

data "aws_organizations_organization" "org" {
  provider = aws.org
}

resource "aws_directory_service_shared_directory" "ad_primary" {
  provider = aws.org

  for_each = { 
    for account in data.aws_organizations_organization.org.non_master_accounts : 
      account.id => account 
      if account.status == "ACTIVE" 
  }

  directory_id = aws_directory_service_directory.ad_primary.id
  target {
    id = each.value.id
  }
  method = "ORGANIZATIONS"
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
  # records = aws_directory_service_directory.ad_primary.dns_ip_addresses
}

#failover
data "aws_vpc" "shared_failover" {
  provider = aws.org_failover

  cidr_block = "${var.vpc_prefixes.shared_vpc.failover}.0.0/16"
  state = "available"
}

data "aws_subnet" "shared_a_failover" {
  provider = aws.org_failover

  cidr_block = "${var.vpc_prefixes.shared_vpc.failover}.${var.vpc_suffixes.subnet_private_a}"
  state = "available"
}

data "aws_subnet" "shared_b_failover" {
  provider = aws.org_failover

  cidr_block = "${var.vpc_prefixes.shared_vpc.failover}.${var.vpc_suffixes.subnet_private_b}"
  state = "available"
}

resource "aws_directory_service_region" "ad_failover" {
  provider = aws.org

  directory_id = aws_directory_service_directory.ad_primary.id
  region_name  = var.region.failover

  vpc_settings {
    vpc_id     = data.aws_vpc.shared_failover.id
    subnet_ids = [data.aws_subnet.shared_a_failover.id, data.aws_subnet.shared_b_failover.id]
  }
}

data "aws_directory_service_directory" "ad_failover" {
  provider = aws.org_failover

  directory_id = split(",", aws_directory_service_region.ad_failover.id)[0]
}

resource "aws_directory_service_shared_directory" "ad_failover" {
  provider = aws.org_failover
  
  for_each = { 
    for account in data.aws_organizations_organization.org.non_master_accounts : 
      account.id => account 
      if account.status == "ACTIVE" 
  }

  directory_id = aws_directory_service_directory.ad_primary.id
  target {
    id = each.value.id
  }
  method = "ORGANIZATIONS"
}

#ad connector
resource "aws_directory_service_directory" "connector_network" {
  provider = aws.network

  name     = "corp.${var.company_domain}"
  password = "tempSuperSecretPassword123"
  size     = "Small"
  type     = "ADConnector"

  connect_settings {
    customer_dns_ips  = aws_directory_service_directory.ad_primary.dns_ip_addresses
    customer_username = "Admin"
    vpc_id     = data.aws_vpc.shared_primary.id
    subnet_ids = [data.aws_subnet.shared_a_primary.id, data.aws_subnet.shared_b_primary.id]
  }
}


