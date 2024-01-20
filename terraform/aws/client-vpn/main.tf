#primary
resource "aws_ec2_client_vpn_endpoint" "client_vpn_primary" {
  provider = aws.network

  server_certificate_arn  = module.acm_wildcard_cert_primary.acm_certificate_arn
  client_cidr_block       = "${var.vpc_prefixes.client_vpn.primary}.0.0/16"
  vpc_id                  = data.aws_vpc.shared_primary.id
  security_group_ids      = [module.client_vpn_sg_primary.security_group_id]

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = module.acm_wildcard_cert_primary.acm_certificate_arn
  }

  connection_log_options {
    enabled               = false
    # cloudwatch_log_group  = aws_cloudwatch_log_group.lg.name
    # cloudwatch_log_stream = aws_cloudwatch_log_stream.ls.name
  }

  tags = {
    Name = "${local.resource_name_stub_env}-client-vpn-primary"
  }
}

data "aws_ec2_managed_prefix_list" "route53_healthchecks_uw1" {
  provider = aws.network_uw1

  name = "com.amazonaws.us-west-1.route53-healthchecks"
}

data "aws_ec2_managed_prefix_list" "route53_healthchecks_uw2" {
  provider = aws.network_uw2

  name = "com.amazonaws.us-west-2.route53-healthchecks"
}

data "aws_ec2_managed_prefix_list" "route53_healthchecks_ue1" {
  provider = aws.network_ue1

  name = "com.amazonaws.us-east-1.route53-healthchecks"
}

locals {
  route53_healthcheck_ips = join(",", sort(distinct([for s in concat(
    tolist(data.aws_ec2_managed_prefix_list.route53_healthchecks_uw1.entries),
    tolist(data.aws_ec2_managed_prefix_list.route53_healthchecks_uw2.entries),
    tolist(data.aws_ec2_managed_prefix_list.route53_healthchecks_ue1.entries),
  ) : s.cidr])))
}

module "client_vpn_sg_primary" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"
  providers = { aws = aws.network }

  name        = "${local.resource_name_stub_env}-client-vpn-primary"
  use_name_prefix = false
  description = "main security group for client-vpn"
  vpc_id      = data.aws_vpc.shared_primary.id

  ingress_with_self = [
    {
      rule = "all-all"
      description = "allow ingress from self"
    },
  ]

  ingress_with_cidr_blocks = [
    {
      from_port   = -1
      to_port     = -1
      protocol    = -1
      description = "allow aws"
      cidr_blocks = "10.0.0.0/8"
    },
    {
      from_port = 443
      to_port   = 443
      protocol  = "tcp"
      description = "allow route53 healthchecks"
      cidr_blocks = local.route53_healthcheck_ips
    },
  ]

  egress_with_self = [
    {
      rule = "all-all"
      description = "allow self"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = -1
      to_port     = -1
      protocol    = -1
      description = "allow internet"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

data "aws_vpc" "shared_primary" {
  provider = aws.shared_services

  cidr_block = "${var.vpc_prefixes.shared_vpc.primary}.0.0/16"
  state = "available"
}

data "aws_subnet" "shared_a_primary" {
  provider = aws.shared_services

  cidr_block = "${var.vpc_prefixes.shared_vpc.primary}.${var.vpc_suffixes.subnet_private_a}"
  state = "available"
}

data "aws_subnet" "shared_b_primary" {
  provider = aws.shared_services

  cidr_block = "${var.vpc_prefixes.shared_vpc.primary}.${var.vpc_suffixes.subnet_private_b}"
  state = "available"
}

resource "aws_ec2_client_vpn_network_association" "shared_a_primary" {
  provider = aws.network

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn_primary.id
  subnet_id              = data.aws_subnet.shared_a_primary.id
}

resource "aws_ec2_client_vpn_network_association" "shared_b_primary" {
  provider = aws.network

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn_primary.id
  subnet_id              = data.aws_subnet.shared_b_primary.id
}

#failover
resource "aws_ec2_client_vpn_endpoint" "client_vpn_failover" {
  provider = aws.network_failover

  server_certificate_arn = module.acm_wildcard_cert_failover.acm_certificate_arn
  client_cidr_block      = "${var.vpc_prefixes.client_vpn.failover}.0.0/16"
  vpc_id                  = data.aws_vpc.shared_failover.id
  security_group_ids      = [module.client_vpn_sg_failover.security_group_id]

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = module.acm_wildcard_cert_failover.acm_certificate_arn
  }

  connection_log_options {
    enabled               = false
    # cloudwatch_log_group  = aws_cloudwatch_log_group.lg.name
    # cloudwatch_log_stream = aws_cloudwatch_log_stream.ls.name
  }

  tags = {
    Name = "${local.resource_name_stub_env}-client-vpn-failover"
  }
}

module "client_vpn_sg_failover" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"
  providers = { aws = aws.network_failover }

  name        = "${local.resource_name_stub_env}-client-vpn-failover"
  use_name_prefix = false
  description = "main security group for client-vpn"
  vpc_id      = data.aws_vpc.shared_failover.id

  ingress_with_self = [
    {
      rule = "all-all"
      description = "allow ingress from self"
    },
  ]

  ingress_with_cidr_blocks = [
    {
      from_port   = -1
      to_port     = -1
      protocol    = -1
      description = "allow ingress from aws"
      cidr_blocks = "10.0.0.0/8"
    },
  ]

  egress_with_self = [
    {
      rule = "all-all"
      description = "allow egress to self"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = -1
      to_port     = -1
      protocol    = -1
      description = "allow egress to internet"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

data "aws_vpc" "shared_failover" {
  provider = aws.shared_services_failover

  cidr_block = "${var.vpc_prefixes.shared_vpc.failover}.0.0/16"
  state = "available"
}

data "aws_subnet" "shared_a_failover" {
  provider = aws.shared_services_failover

  cidr_block = "${var.vpc_prefixes.shared_vpc.failover}.${var.vpc_suffixes.subnet_private_a}"
  state = "available"
}

data "aws_subnet" "shared_b_failover" {
  provider = aws.shared_services_failover

  cidr_block = "${var.vpc_prefixes.shared_vpc.failover}.${var.vpc_suffixes.subnet_private_b}"
  state = "available"
}

resource "aws_ec2_client_vpn_network_association" "shared_a_failover" {
  provider = aws.network_failover

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn_failover.id
  subnet_id              = data.aws_subnet.shared_a_failover.id
}

resource "aws_ec2_client_vpn_network_association" "shared_b_failover" {
  provider = aws.network_failover

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn_failover.id
  subnet_id              = data.aws_subnet.shared_b_failover.id
}

#dns
resource "aws_route53_health_check" "client_vpn_primary" {
  provider = aws.network

  fqdn              = replace(aws_ec2_client_vpn_endpoint.client_vpn_primary.dns_name, "/.*\\.cvpn-endpoint/", "healthcheck.cvpn-endpoint")
  port              = 443
  type              = "TCP"
  failure_threshold = "3"
  request_interval  = "30"
  measure_latency   = true
  regions           = [
    "us-east-1",
    "us-west-1",
    "us-west-2",
  ]

  tags = {
    Name = "${local.resource_name_stub_env}-client-vpn-healthcheck-primary"
  }
}

resource "aws_route53_health_check" "client_vpn_failover" {
  provider = aws.network_failover
  
  fqdn              = replace(aws_ec2_client_vpn_endpoint.client_vpn_failover.dns_name, "/.*\\.cvpn-endpoint/", "healthcheck.cvpn-endpoint")
  port              = 443
  type              = "TCP"
  failure_threshold = "3"
  request_interval  = "30"
  measure_latency   = true
  regions           = [
    "us-east-1",
    "us-west-1",
    "us-west-2",
  ]

  tags = {
    Name = "${local.resource_name_stub_env}-client-vpn-healthcheck-failover"
  }
}

module "client_vpn_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "2.11.0"
  providers = { aws = aws.network }

  zone_name = var.company_domain

  records = [
    {
      name = "*.vpn"
      type = "CNAME"
      ttl  = 600
      records = [
        "vpn.${var.company_domain}",
      ]
    },
    {
      name = "vpn"
      type = "CNAME"
      set_identifier = "vpn-primary"
      # health_check_id = aws_route53_health_check.client_vpn_primary.id
      ttl  = 600
      records = [
        "${aws_ec2_client_vpn_endpoint.client_vpn_primary.dns_name}",
      ]
      latency_routing_policy = {
        region = var.region.primary
      }
    },
    {
      name = "vpn"
      type = "CNAME"
      set_identifier = "vpn-failover"
      # health_check_id = aws_route53_health_check.client_vpn_failover.id
      ttl  = 600
      records = [
        "${aws_ec2_client_vpn_endpoint.client_vpn_failover.dns_name}",
      ]
      latency_routing_policy = {
        region = var.region.failover
      }
    },
  ]
}
