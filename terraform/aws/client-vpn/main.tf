#primary
data "aws_caller_identity" "network" {
  provider = aws.network
}

resource "aws_ec2_client_vpn_endpoint" "client_vpn_primary" {
  provider = aws.network

  server_certificate_arn  = module.acm_wildcard_cert_primary.acm_certificate_arn
  client_cidr_block       = "${var.vpc_cidr_clientvpn_primary}"
  transport_protocol      = "tcp"
  vpc_id                  = data.aws_vpc.network_primary.id
  security_group_ids      = [
    module.client_vpn_endpoint_sg_primary.security_group_id,
    module.client_vpn_endpoint_r53_healthcheck_sg_primary.security_group_id,
  ]

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = module.acm_wildcard_cert_primary.acm_certificate_arn
  }

  authentication_options {
    type                = "directory-service-authentication"
    active_directory_id = var.ad_directory_id_connector_network
  }

  connection_log_options {
    enabled               = false
    # cloudwatch_log_group  = aws_cloudwatch_log_group.lg.name
    # cloudwatch_log_stream = aws_cloudwatch_log_stream.ls.name
  }

  tags = {
    Name = "${local.resource_name_prefix_env}-client-vpn-primary"
  }
}

data "aws_ec2_managed_prefix_list" "route53_healthchecks_primary" {
  provider = aws.network

  name = "com.amazonaws.${var.region.primary}.route53-healthchecks"
}

data "aws_ec2_managed_prefix_list" "route53_healthchecks_failover" {
  provider = aws.network_failover

  name = "com.amazonaws.${var.region.failover}.route53-healthchecks"
}

module "client_vpn_endpoint_sg_primary" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"
  providers = { aws = aws.network }

  name        = "${local.resource_name_prefix_env}-client-vpn-endpoint-primary"
  use_name_prefix = false
  description = "main sg for client-vpn endpoint"
  vpc_id      = data.aws_vpc.network_primary.id

  computed_ingress_with_self = [
      {
        from_port   = -1
        to_port     = -1
        protocol    = -1
        description = "allow self"
        self        = true
      },      
    ]
  number_of_computed_ingress_with_self = 1

  computed_ingress_with_cidr_blocks = [
    {
      from_port   = -1
      to_port     = -1
      protocol    = -1
      description = "allow internet"
      cidr_blocks = "0.0.0.0/0"
    },    
  ]
  number_of_computed_ingress_with_cidr_blocks = 1

  computed_egress_with_self = [
    {
      from_port   = -1
      to_port     = -1
      protocol    = -1
      description = "allow self"
      self        = true
    },    
  ]
  number_of_computed_egress_with_self = 1

  computed_egress_with_cidr_blocks = [
    {
      from_port   = -1
      to_port     = -1
      protocol    = -1
      description = "allow internet"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  number_of_computed_egress_with_cidr_blocks = 1
}

module "client_vpn_endpoint_r53_healthcheck_sg_primary" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"
  providers = { aws = aws.network }

  name        = "${local.resource_name_prefix_env}-client-vpn-endpoint-r53-healthcheck-primary"
  use_name_prefix = false
  description = "r53 healthcheck sg for client-vpn endpoint"
  vpc_id      = data.aws_vpc.network_primary.id

  ingress_prefix_list_ids = [data.aws_ec2_managed_prefix_list.route53_healthchecks_primary.id]
  ingress_with_prefix_list_ids = [
    {
      from_port = 443
      to_port   = 443
      protocol  = "tcp"
    },
  ]

  egress_prefix_list_ids = [data.aws_ec2_managed_prefix_list.route53_healthchecks_primary.id]
  egress_with_prefix_list_ids = [
    {
      from_port = 443
      to_port   = 443
      protocol  = "tcp"
    },
  ]
}

data "aws_vpc" "network_primary" {
  provider = aws.network

  cidr_block = "${var.vpc_cidr_network_primary}"
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

resource "aws_ec2_client_vpn_network_association" "primary" {
  provider = aws.network

  count = length(data.aws_subnets.network_primary.ids)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn_primary.id
  subnet_id              = element(data.aws_subnets.network_primary.ids, count.index)
}

#failover
resource "aws_ec2_client_vpn_endpoint" "client_vpn_failover" {
  provider = aws.network_failover

  server_certificate_arn = module.acm_wildcard_cert_failover.acm_certificate_arn
  client_cidr_block      = "${var.vpc_cidr_clientvpn_failover}"
  vpc_id                 = data.aws_vpc.network_failover.id
  transport_protocol     = "tcp"
  security_group_ids     = [
    module.client_vpn_endpoint_sg_failover.security_group_id,
    module.client_vpn_endpoint_r53_healthcheck_sg_failover.security_group_id,
  ]

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = module.acm_wildcard_cert_failover.acm_certificate_arn
  }

  authentication_options {
    type                = "directory-service-authentication"
    active_directory_id = var.ad_directory_id_connector_network_failover
  }

  connection_log_options {
    enabled               = false
    # cloudwatch_log_group  = aws_cloudwatch_log_group.lg.name
    # cloudwatch_log_stream = aws_cloudwatch_log_stream.ls.name
  }

  tags = {
    Name = "${local.resource_name_prefix_env}-client-vpn-failover"
  }
}

module "client_vpn_endpoint_sg_failover" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"
  providers = { aws = aws.network_failover }

  name        = "${local.resource_name_prefix_env}-client-vpn-endpoint-failover"
  use_name_prefix = false
  description = "main sg for client-vpn endpoint"
  vpc_id      = data.aws_vpc.network_failover.id

  computed_ingress_with_self = [
      {
        from_port   = -1
        to_port     = -1
        protocol    = -1
        description = "allow self"
        self        = true
      },      
    ]
  number_of_computed_ingress_with_self = 1

  computed_ingress_with_cidr_blocks = [
    {
      from_port   = -1
      to_port     = -1
      protocol    = -1
      description = "allow internet"
      cidr_blocks = "0.0.0.0/0"
    },    
  ]
  number_of_computed_ingress_with_cidr_blocks = 1

  computed_egress_with_self = [
    {
      from_port   = -1
      to_port     = -1
      protocol    = -1
      description = "allow self"
      self        = true
    },    
  ]
  number_of_computed_egress_with_self = 1

  computed_egress_with_cidr_blocks = [
    {
      from_port   = -1
      to_port     = -1
      protocol    = -1
      description = "allow internet"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  number_of_computed_egress_with_cidr_blocks = 1
}

module "client_vpn_endpoint_r53_healthcheck_sg_failover" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"
  providers = { aws = aws.network_failover }

  name        = "${local.resource_name_prefix_env}-client-vpn-endpoint-r53-healthcheck-failover"
  use_name_prefix = false
  description = "r53 healthcheck sg for client-vpn endpoint"
  vpc_id      = data.aws_vpc.network_failover.id

  ingress_prefix_list_ids = [data.aws_ec2_managed_prefix_list.route53_healthchecks_failover.id]
  ingress_with_prefix_list_ids = [
    {
      from_port = 443
      to_port   = 443
      protocol  = "tcp"
    },
  ]

  egress_prefix_list_ids = [data.aws_ec2_managed_prefix_list.route53_healthchecks_failover.id]
  egress_with_prefix_list_ids = [
    {
      from_port = 443
      to_port   = 443
      protocol  = "tcp"
    },
  ]
}

data "aws_vpc" "network_failover" {
  provider = aws.network_failover

  cidr_block = "${var.vpc_cidr_network_failover}"
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


resource "aws_ec2_client_vpn_network_association" "failover" {
  provider = aws.network_failover

  count = length(data.aws_subnets.network_failover.ids)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn_failover.id
  subnet_id              = element(data.aws_subnets.network_failover.ids, count.index)
}

#dns
resource "aws_route53_health_check" "client_vpn_primary" {
  provider = aws.network

  fqdn              = replace(aws_ec2_client_vpn_endpoint.client_vpn_primary.dns_name, "/.*\\.cvpn-endpoint/", "healthcheck.cvpn-endpoint")
  port              = 443
  type              = "TCP"
  request_interval  = "30"
  measure_latency   = true
  regions           = [
    "us-east-1",
    "us-west-1",
    "us-west-2",
  ]

  tags = {
    Name = "${local.resource_name_prefix_env}-client-vpn-healthcheck-primary"
  }
}

resource "aws_route53_health_check" "client_vpn_failover" {
  provider = aws.network_failover
  
  fqdn              = replace(aws_ec2_client_vpn_endpoint.client_vpn_failover.dns_name, "/.*\\.cvpn-endpoint/", "healthcheck.cvpn-endpoint")
  port              = 443
  type              = "TCP"
  request_interval  = "30"
  measure_latency   = true
  regions           = [
    "us-east-1",
    "us-west-1",
    "us-west-2",
  ]

  tags = {
    Name = "${local.resource_name_prefix_env}-client-vpn-healthcheck-failover"
  }
}

module "client_vpn_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "4.1.0"
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
      health_check_id = aws_route53_health_check.client_vpn_primary.id
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
      health_check_id = aws_route53_health_check.client_vpn_failover.id
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
