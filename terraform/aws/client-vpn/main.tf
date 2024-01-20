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

  egress_with_self = [
    {
      rule = "all-all"
      description = "allow egress to self"
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

  egress_with_self = [
    {
      rule = "all-all"
      description = "allow egress to self"
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
module "client_vpn_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "2.11.0"
  providers = { aws = aws.network }

  zone_name = var.company_domain

  records = [
    {
      name = "*.vpn"
      type = "CNAME"
      ttl  = 300
      records = [
        "vpn.${var.company_domain}",
      ]
    },
    {
      name = "vpn"
      type = "CNAME"
      set_identifier = "vpn-primary"
      ttl  = 300
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
      ttl  = 300
      records = [
        "${aws_ec2_client_vpn_endpoint.client_vpn_failover.dns_name}",
      ]
      latency_routing_policy = {
        region = var.region.failover
      }
    },
  ]
}
