#tgw
data "aws_organizations_organization" "current" {
  provider = aws.network
}

module "tgw_primary" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "2.12.1"
  providers = { aws = aws.network }

  name = "${local.resource_name_stub_env}-tgw-primary"

  amazon_side_asn = var.tgw_asn.primary
  enable_auto_accept_shared_attachments = true
  create_tgw_routes = false

  ram_name = "${local.resource_name_stub_env}-ram-tgw-primary"
  ram_allow_external_principals = false
  ram_principals = [data.aws_organizations_organization.current.arn]
}

module "tgw_failover" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "2.12.1"
  providers = { aws = aws.network_failover }

  name = "${local.resource_name_stub_env}-tgw-failover"

  amazon_side_asn = var.tgw_asn.failover
  enable_auto_accept_shared_attachments = true
  create_tgw_routes = false

  ram_name = "${local.resource_name_stub_env}-ram-tgw-failover"
  ram_allow_external_principals = false
  ram_principals = [data.aws_organizations_organization.current.arn]
}

data "aws_caller_identity" "network" {
  provider = aws.network
}

resource "aws_ec2_transit_gateway_peering_attachment" "tgw_peering" {
  provider = aws.network_failover

  peer_account_id                     = data.aws_caller_identity.network.account_id
  peer_region                         = var.region.primary
  peer_transit_gateway_id             = module.tgw_primary.ec2_transit_gateway_id
  transit_gateway_id                  = module.tgw_failover.ec2_transit_gateway_id
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "tgw_peering" {
  provider = aws.network
  
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.tgw_peering.id
}

#vpc
resource "aws_eip" "vpc_nat_primary" {
  provider = aws.network

  count = 2
  domain = "vpc"
  tags = { "Name" = "${local.resource_name_stub_env}-primary-${count.index}" }

  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE
}

module "vpc_primary" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.4.0"
  providers = { aws = aws.network }

  enable_nat_gateway = true
  reuse_nat_ips = true
  one_nat_gateway_per_az = true
  external_nat_ip_ids = aws_eip.vpc_nat_primary[*].id
  external_nat_ips = aws_eip.vpc_nat_primary[*].public_ip

  name = "${local.resource_name_stub_env}-vpc-primary"
  public_subnet_suffix = "pub"
  private_subnet_suffix = "pvt"
  cidr = "${var.vpc_prefixes.shared_vpc.primary}.0.0/16"

  azs = var.availability_zones.primary
  public_subnets = [
    "${var.vpc_prefixes.shared_vpc.primary}.${var.vpc_suffixes.subnet_public_a}",
    "${var.vpc_prefixes.shared_vpc.primary}.${var.vpc_suffixes.subnet_public_b}",
  ]
  private_subnets = [
    "${var.vpc_prefixes.shared_vpc.primary}.${var.vpc_suffixes.subnet_private_a}",
    "${var.vpc_prefixes.shared_vpc.primary}.${var.vpc_suffixes.subnet_private_b}",
  ]

  public_subnet_tags = { "kubernetes.io/role/elb" = 1 }
  private_subnet_tags = { "kubernetes.io/role/internal-elb" = 1 }
  vpc_tags = {
    "${local.resource_name_stub_env}-cluster-primary-blue"   = "shared"
    "${local.resource_name_stub_env}-cluster-primary-green"  = "shared"
    "k8s.io/cluster-autoscaler/enabled" = "true"
    "k8s.io/cluster-autoscaler/${local.resource_name_stub_env}-cluster-primary-blue" = "shared"
    "k8s.io/cluster-autoscaler/${local.resource_name_stub_env}-cluster-primary-green" = "shared"
    "kubernetes.io/cluster/${local.resource_name_stub_env}-cluster-primary-blue" = "shared"
    "kubernetes.io/cluster/${local.resource_name_stub_env}-cluster-primary-green" = "shared"
  }

  manage_default_security_group = true
  default_security_group_name = "NEVER-USE-THIS-SECURITY-GROUP"
  default_security_group_ingress = []
  default_security_group_egress = []

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_dhcp_options = true
  dhcp_options_domain_name_servers = ["${var.vpc_prefixes.shared_vpc.primary}.0.2"]
  dhcp_options_ntp_servers = local.vpc_ntp_servers
}

#vpc security groups
module "vpc_main_sg_primary" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"
  providers = { aws = aws.network }

  name        = "${local.resource_name_stub_env}-main"
  use_name_prefix = false
  description = "main security group for ${local.resource_name_stub_env}"
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
      cidr_blocks = "${var.vpc_prefixes.client_vpn.primary}.0.0/16"
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
  version = "5.1.0"
  providers = { aws = aws.network }

  name  = "${local.resource_name_stub_env}-alb"
  use_name_prefix = false
  description = "load balancer security group for ${local.resource_name_stub_env}"
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
      cidr_blocks = "${var.vpc_prefixes.client_vpn.primary}.0.0/16"
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
  version = "5.4.0"
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
      tags                = { Name = "${local.resource_name_stub_env}-s3-vpc-endpoint-primary" }
    },
    rds = {
      # interface endpoint
      service             = "rds"
      # service_type  = "Gateway"
      private_dns_enabled = true
      # security_group_ids  = [module.vpc_main_sg_primary.security_group_id]
      subnet_ids = module.vpc_primary.private_subnets
      # route_table_ids = flatten([module.vpc_primary.private_route_table_ids, module.vpc_primary.public_route_table_ids])
      tags                = { Name = "${local.resource_name_stub_env}-rds-endpoint-primary" }
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

resource "aws_eip" "vpc_nat_failover" {
  provider = aws.network_failover

  count = 2
  domain = "vpc"
  tags = { "Name" = "${local.resource_name_stub_env}-failover-${count.index}" }

  # lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE
}

module "vpc_failover" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.4.0"
  providers = { aws = aws.network_failover }

  enable_nat_gateway = true
  reuse_nat_ips = true
  one_nat_gateway_per_az = true
  external_nat_ip_ids = aws_eip.vpc_nat_failover[*].id
  external_nat_ips = aws_eip.vpc_nat_failover[*].public_ip

  name = "${local.resource_name_stub_env}-vpc-failover"
  public_subnet_suffix = "pub"
  private_subnet_suffix = "pvt"
  cidr = "${var.vpc_prefixes.shared_vpc.failover}.0.0/16"

  azs = var.availability_zones.failover
  public_subnets = [
    "${var.vpc_prefixes.shared_vpc.failover}.${var.vpc_suffixes.subnet_public_a}",
    "${var.vpc_prefixes.shared_vpc.failover}.${var.vpc_suffixes.subnet_public_b}",
  ]
  private_subnets = [
    "${var.vpc_prefixes.shared_vpc.failover}.${var.vpc_suffixes.subnet_private_a}",
    "${var.vpc_prefixes.shared_vpc.failover}.${var.vpc_suffixes.subnet_private_b}",
  ]

  public_subnet_tags = { "kubernetes.io/role/elb" = 1 }
  private_subnet_tags = { "kubernetes.io/role/internal-elb" = 1 }
  vpc_tags = {
    "${local.resource_name_stub_env}-cluster-failover-blue"   = "shared"
    "${local.resource_name_stub_env}-cluster-failover-green"  = "shared"
  }

  manage_default_security_group = true
  default_security_group_name = "NEVER-USE-THIS-SECURITY-GROUP"
  default_security_group_ingress = []
  default_security_group_egress = []

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_dhcp_options = true
  dhcp_options_domain_name_servers = ["${var.vpc_prefixes.shared_vpc.failover}.0.2"]
  dhcp_options_ntp_servers = local.vpc_ntp_servers
}

#vpc security groups
module "vpc_main_sg_failover" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"
  providers = { aws = aws.network_failover }

  name        = "${local.resource_name_stub_env}-main"
  use_name_prefix = false
  description = "main security group for ${local.resource_name_stub_env}"
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
      cidr_blocks = "${var.vpc_prefixes.client_vpn.failover}.0.0/16"
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
  version = "5.1.0"
  providers = { aws = aws.network_failover }

  name  = "${local.resource_name_stub_env}-alb"
  use_name_prefix = false
  description = "load balancer security group for ${local.resource_name_stub_env}"
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
      cidr_blocks = "${var.vpc_prefixes.client_vpn.failover}.0.0/16"
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
  version = "5.4.0"
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
      tags                = { Name = "${local.resource_name_stub_env}-s3-vpc-endpoint-failover" }
    },
    rds = {
      # interface endpoint
      service             = "rds"
      # service_type  = "Gateway"
      private_dns_enabled = true
      # security_group_ids  = [module.vpc_main_sg_primary.security_group_id]
      subnet_ids = module.vpc_failover.private_subnets
      # route_table_ids = flatten([module.vpc_primary.private_route_table_ids, module.vpc_primary.public_route_table_ids])
      tags                = { Name = "${local.resource_name_stub_env}-rds-endpoint-failover" }
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

#vpc ram
resource "aws_ram_resource_share" "primary" {
  provider = aws.network

  name                      = "${local.resource_name_stub_env}-ram-vpc-primary"
  allow_external_principals = false
}

resource "aws_ram_principal_association" "primary" {
  provider = aws.network

  principal          = data.aws_organizations_organization.current.arn
  resource_share_arn = aws_ram_resource_share.primary.arn
}

resource "aws_ram_resource_association" "primary" {
  provider = aws.network

  count = length(module.vpc_primary.private_subnet_arns)
  resource_arn       = module.vpc_primary.private_subnet_arns[count.index]
  resource_share_arn = aws_ram_resource_share.primary.arn
}

resource "aws_ram_resource_share" "failover" {
  provider = aws.network_failover

  name  = "${local.resource_name_stub_env}-ram-vpc-failover"
  allow_external_principals = false
}

resource "aws_ram_principal_association" "failover" {
  provider = aws.network_failover

  principal          = data.aws_organizations_organization.current.arn
  resource_share_arn = aws_ram_resource_share.failover.arn
}

resource "aws_ram_resource_association" "failover" {
  provider = aws.network_failover

  count = length(module.vpc_failover.private_subnet_arns)
  resource_arn       = module.vpc_failover.private_subnet_arns[count.index]
  resource_share_arn = aws_ram_resource_share.failover.arn
}