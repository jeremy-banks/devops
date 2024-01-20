#primary
resource "aws_ec2_client_vpn_endpoint" "client_vpn_primary" {
  provider = aws.network

  server_certificate_arn = module.acm_wildcard_cert_primary.acm_certificate_arn
  client_cidr_block      = "${var.vpc_prefixes.client_vpn.primary}.0.0/16"

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

# data "aws_vpc" "shared_primary" {
#   provider = aws.shared_services

#   cidr_block = "${var.vpc_prefixes.shared_vpc.primary}.0.0/16"
#   state = "available"
# }

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

# data "aws_vpc" "shared_failover" {
#   provider = aws.shared_services_failover

#   cidr_block = "${var.vpc_prefixes.shared_vpc.failover}.0.0/16"
#   state = "available"
# }

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
