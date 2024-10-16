locals {
  vpc_tags_primary = {
    "${local.resource_name_stub}-${var.region.failover_short}-cluster-blue"   = "shared"
    "${local.resource_name_stub}-${var.region.failover_short}-cluster-green"  = "shared"
    "k8s.io/cluster-autoscaler/enabled" = "true"
    "k8s.io/cluster-autoscaler/${local.resource_name_stub}-${var.region.failover_short}-cluster-blue" = "shared"
    "k8s.io/cluster-autoscaler/${local.resource_name_stub}-${var.region.failover_short}-cluster-green" = "shared"
    "kubernetes.io/cluster/${local.resource_name_stub}-${var.region.failover_short}-cluster-blue" = "shared"
    "kubernetes.io/cluster/${local.resource_name_stub}-${var.region.failover_short}-cluster-green" = "shared"
  }
  public_subnet_tags_primary = { "kubernetes.io/role/elb" = 1 }
  private_subnet_tags_primary = { "kubernetes.io/role/internal-elb" = 1 }

  vpc_tags_failover = {
    "${local.resource_name_stub}-${var.region.failover_short}-cluster-blue"   = "shared"
    "${local.resource_name_stub}-${var.region.failover_short}-cluster-green"  = "shared"
  }
  public_subnet_tags_failover = local.public_subnet_tags_primary
  private_subnet_tags_failover = local.private_subnet_tags_primary
}

module "vpc_primary" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"
  providers = { aws = aws.network }

  enable_nat_gateway = true
  reuse_nat_ips = true
  one_nat_gateway_per_az = true
  external_nat_ip_ids = aws_eip.vpc_nat_primary[*].id
  external_nat_ips = aws_eip.vpc_nat_primary[*].public_ip

  name = "${local.resource_name_stub}-${var.region.failover_short}-vpc"
  public_subnet_suffix = "pub"
  private_subnet_suffix = "pvt"
  cidr = local.vpc_cidr_primary

  azs = local.vpc_azs_primary
  public_subnets = local.vpc_subnets_public_primary
  private_subnets = local.vpc_subnets_private_primary

  public_subnet_tags = local.public_subnet_tags_primary
  private_subnet_tags = local.private_subnet_tags_primary
  vpc_tags = local.vpc_tags_primary

  manage_default_security_group = true
  default_security_group_name = "NEVER-USE-THIS-SECURITY-GROUP"
  default_security_group_ingress = []
  default_security_group_egress = []

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_dhcp_options = true
  dhcp_options_domain_name_servers = [local.vpc_dns_primary]
  dhcp_options_ntp_servers = local.vpc_ntp_servers
}

#vpc security groups
module "vpc_main_sg_primary" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"
  providers = { aws = aws.network }

  name        = "${local.resource_name_stub}-${var.region.failover_short}-main"
  use_name_prefix = false
  description = "main security group for ${local.resource_name_stub}-${var.region.failover_short}"
  vpc_id      = module.vpc_primary.vpc_id

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
      description = "allow ingress from client-vpn"
      cidr_blocks = "${var.vpc_cidr_clientvpn_primary},${var.vpc_cidr_clientvpn_failover}"
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 1
  computed_ingress_with_source_security_group_id = [
    {
      rule  = "all-all"
      source_security_group_id = module.vpc_alb_sg_primary.security_group_id
      description = "allow ingress from ${module.vpc_alb_sg_primary.security_group_name}"
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

  number_of_computed_egress_with_source_security_group_id = 1
  computed_egress_with_source_security_group_id = [
    {
      rule  = "all-all"
      source_security_group_id = module.vpc_alb_sg_primary.security_group_id
      description = "allow egress to ${module.vpc_alb_sg_primary.security_group_name}"
    },
  ]
}

module "vpc_alb_sg_primary" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"
  providers = { aws = aws.network }

  name  = "${local.resource_name_stub}-${var.region.failover_short}-alb"
  use_name_prefix = false
  description = "load balancer security group for ${local.resource_name_stub}-${var.region.failover_short}"
  vpc_id  = module.vpc_primary.vpc_id

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
      description = "allow ingress from client-vpn"
      cidr_blocks = "${var.vpc_cidr_clientvpn_primary},${var.vpc_cidr_clientvpn_failover}"
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 1
  computed_ingress_with_source_security_group_id = [
    {
      rule  = "all-all"
      source_security_group_id = module.vpc_main_sg_primary.security_group_id
      description = "allow ingress from ${module.vpc_main_sg_primary.security_group_name}"
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

  number_of_computed_egress_with_source_security_group_id = 1
  computed_egress_with_source_security_group_id = [
    {
      rule  = "all-all"
      source_security_group_id  = module.vpc_main_sg_primary.security_group_id
      description = "allow egress to ${module.vpc_main_sg_primary.security_group_name}"
    },
  ]
}

#vpc endpoints
module "vpc_endpoints_primary" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.13.0"
  providers = { aws = aws.network }

  vpc_id             = module.vpc_primary.vpc_id
  security_group_ids = [module.vpc_main_sg_primary.security_group_id]

  endpoints = {
    s3 = {
      # interface endpoint
      service             = "s3"
      service_type  = "Gateway"
      # private_dns_enabled = true
      # security_group_ids  = [module.vpc_main_sg_primary.security_group_id]
      subnet_ids = module.vpc_primary.private_subnets
      route_table_ids = flatten([module.vpc_primary.private_route_table_ids, module.vpc_primary.public_route_table_ids])
      tags                = { Name = "${local.resource_name_stub}-${var.region.failover_short}-s3-vpc-endpoint" }
    },
    rds = {
      # interface endpoint
      service             = "rds"
      # service_type  = "Gateway"
      private_dns_enabled = true
      # security_group_ids  = [module.vpc_main_sg_primary.security_group_id]
      subnet_ids = module.vpc_primary.private_subnets
      # route_table_ids = flatten([module.vpc_primary.private_route_table_ids, module.vpc_primary.public_route_table_ids])
      tags                = { Name = "${local.resource_name_stub}-${var.region.failover_short}-rds-endpoint" }
    },
    # dynamodb = {
    #   # gateway endpoint
    #   service         = "dynamodb"
    #   route_table_ids = ["rt-12322456", "rt-43433343", "rt-11223344"]
    #   tags            = { Name = "dynamodb-vpc-endpoint" }
    # },
    # sns = {
    #   service    = "sns"
    #   subnet_ids = ["subnet-12345678", "subnet-87654321"]
    #   tags       = { Name = "sns-vpc-endpoint" }
    # },
    # sqs = {
    #   service             = "sqs"
    #   private_dns_enabled = true
    #   security_group_ids  = ["sg-987654321"]
    #   subnet_ids          = ["subnet-12345678", "subnet-87654321"]
    #   tags                = { Name = "sqs-vpc-endpoint" }
    # },
  }
}

#vpc tgw attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_primary" {
  provider = aws.network

  subnet_ids         = module.vpc_primary.private_subnets
  transit_gateway_id = module.tgw_primary.ec2_transit_gateway_id
  vpc_id             = module.vpc_primary.vpc_id
}

module "vpc_failover" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"
  providers = { aws = aws.network_failover }

  enable_nat_gateway = true
  reuse_nat_ips = true
  one_nat_gateway_per_az = true
  external_nat_ip_ids = aws_eip.vpc_nat_failover[*].id
  external_nat_ips = aws_eip.vpc_nat_failover[*].public_ip

  name = "${local.resource_name_stub}-${var.region.failover_short}-vpc"
  public_subnet_suffix = "pub"
  private_subnet_suffix = "pvt"
  cidr = local.vpc_cidr_failover

  azs = local.vpc_azs_failover
  public_subnets = local.vpc_subnets_public_failover
  private_subnets = local.vpc_subnets_private_failover

  public_subnet_tags = local.public_subnet_tags_failover
  private_subnet_tags = local.private_subnet_tags_failover
  vpc_tags = local.vpc_tags_failover

  manage_default_security_group = true
  default_security_group_name = "NEVER-USE-THIS-SECURITY-GROUP"
  default_security_group_ingress = []
  default_security_group_egress = []

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_dhcp_options = true
  dhcp_options_domain_name_servers = [local.vpc_dns_failover]
  dhcp_options_ntp_servers = local.vpc_ntp_servers
}

#vpc security groups
module "vpc_main_sg_failover" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"
  providers = { aws = aws.network_failover }

  name        = "${local.resource_name_stub}-${var.region.failover_short}-main"
  use_name_prefix = false
  description = "main security group for ${local.resource_name_stub}-${var.region.failover_short}"
  vpc_id      = module.vpc_failover.vpc_id

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
      description = "allow ingress from client-vpn"
      cidr_blocks = "${var.vpc_cidr_clientvpn_primary},${var.vpc_cidr_clientvpn_failover}"
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 1
  computed_ingress_with_source_security_group_id = [
    {
      rule  = "all-all"
      source_security_group_id = module.vpc_alb_sg_failover.security_group_id
      description = "allow ingress from ${module.vpc_alb_sg_failover.security_group_name}"
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

  number_of_computed_egress_with_source_security_group_id = 1
  computed_egress_with_source_security_group_id = [
    {
      rule  = "all-all"
      source_security_group_id = module.vpc_alb_sg_failover.security_group_id
      description = "allow egress to ${module.vpc_alb_sg_failover.security_group_name}"
    },
  ]
}

module "vpc_alb_sg_failover" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"
  providers = { aws = aws.network_failover }

  name  = "${local.resource_name_stub}-${var.region.failover_short}-alb"
  use_name_prefix = false
  description = "load balancer security group for ${local.resource_name_stub}-${var.region.failover_short}"
  vpc_id  = module.vpc_failover.vpc_id

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
      description = "allow ingress from client-vpn"
      cidr_blocks = "${var.vpc_cidr_clientvpn_primary},${var.vpc_cidr_clientvpn_failover}"
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 1
  computed_ingress_with_source_security_group_id = [
    {
      rule  = "all-all"
      source_security_group_id = module.vpc_main_sg_failover.security_group_id
      description = "allow ingress from ${module.vpc_main_sg_failover.security_group_name}"
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

  number_of_computed_egress_with_source_security_group_id = 1
  computed_egress_with_source_security_group_id = [
    {
      rule  = "all-all"
      source_security_group_id  = module.vpc_main_sg_failover.security_group_id
      description = "allow egress to ${module.vpc_main_sg_failover.security_group_name}"
    },
  ]
}

#vpc endpoints
module "vpc_endpoints_failover" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.13.0"
  providers = { aws = aws.network_failover }

  vpc_id             = module.vpc_failover.vpc_id
  security_group_ids = [module.vpc_main_sg_failover.security_group_id]

  endpoints = {
    s3 = {
      # interface endpoint
      service             = "s3"
      service_type  = "Gateway"
      # private_dns_enabled = true
      # security_group_ids  = [module.vpc_main_sg_primary.security_group_id]
      subnet_ids = module.vpc_failover.private_subnets
      route_table_ids = flatten([module.vpc_failover.private_route_table_ids, module.vpc_failover.public_route_table_ids])
      tags                = { Name = "${local.resource_name_stub}-${var.region.failover_short}-s3-vpc-endpoint" }
    },
    rds = {
      # interface endpoint
      service             = "rds"
      # service_type  = "Gateway"
      private_dns_enabled = true
      # security_group_ids  = [module.vpc_main_sg_primary.security_group_id]
      subnet_ids = module.vpc_failover.private_subnets
      # route_table_ids = flatten([module.vpc_primary.private_route_table_ids, module.vpc_primary.public_route_table_ids])
      tags                = { Name = "${local.resource_name_stub}-${var.region.failover_short}-rds-endpoint" }
    },
    # dynamodb = {
    #   # gateway endpoint
    #   service         = "dynamodb"
    #   route_table_ids = ["rt-12322456", "rt-43433343", "rt-11223344"]
    #   tags            = { Name = "dynamodb-vpc-endpoint" }
    # },
    # sns = {
    #   service    = "sns"
    #   subnet_ids = ["subnet-12345678", "subnet-87654321"]
    #   tags       = { Name = "sns-vpc-endpoint" }
    # },
    # sqs = {
    #   service             = "sqs"
    #   private_dns_enabled = true
    #   security_group_ids  = ["sg-987654321"]
    #   subnet_ids          = ["subnet-12345678", "subnet-87654321"]
    #   tags                = { Name = "sqs-vpc-endpoint" }
    # },
  }
}

#vpc tgw attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_failover" {
  provider = aws.network_failover

  subnet_ids         = module.vpc_failover.private_subnets
  transit_gateway_id = module.tgw_failover.ec2_transit_gateway_id
  vpc_id             = module.vpc_failover.vpc_id
}