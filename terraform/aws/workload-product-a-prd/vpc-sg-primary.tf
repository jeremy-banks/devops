module "sg_main_primary" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.3.0"
  providers = { aws = aws.this }

  name        = "${local.resource_name_stub_primary}-${var.this_slug}-main-sg"
  description = "${local.resource_name_stub_primary}-${var.this_slug}-main-sg"
  vpc_id      = module.vpc_primary.vpc_id

  tags = { Name = "${local.resource_name_stub_primary}-${var.this_slug}-main-sg" }
}

module "sg_main_rules_primary" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.3.0"
  providers = { aws = aws.this }

  create_sg         = false
  security_group_id = module.sg_main_primary.security_group_id

  ingress_with_self = [
    {
      description = "allow all from self"
      rule        = "all-all"
    },
  ]

  egress_with_self = [
    {
      description = "allow all to self"
      rule        = "all-all"
    },
  ]

  ingress_with_cidr_blocks = var.create_failover_region_networking ? [
    {
      description = "allow all from client vpn"
      rule        = "all-all"
      cidr_blocks = "${var.vpc_cidr_infrastructure.client_vpn_prd_primary},${var.vpc_cidr_infrastructure.client_vpn_prd_failover},${var.vpc_cidr_infrastructure.client_vpn_stg_primary},${var.vpc_cidr_infrastructure.client_vpn_stg_failover}"
    },
    ] : [
    {
      description = "allow all from client vpn"
      rule        = "all-all"
      cidr_blocks = "${var.vpc_cidr_infrastructure.client_vpn_prd_primary},${var.vpc_cidr_infrastructure.client_vpn_stg_primary}"
    },
  ]

  egress_with_cidr_blocks = [
    {
      description = "allow all to ipv4 internet"
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_with_ipv6_cidr_blocks = [
    {
      description = "allow all to ipv6 internet"
      rule        = "all-all"
      cidr_blocks = "::/0"
    },
  ]

  ingress_with_source_security_group_id = [
    {
      description              = "allow all from ingress sg"
      rule                     = "all-all"
      source_security_group_id = module.sg_ingress_primary.security_group_id
    },
  ]
}

module "sg_ingress_primary" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.3.0"
  providers = { aws = aws.this }

  name        = "${local.resource_name_stub_primary}-${var.this_slug}-ingress-sg"
  description = "${local.resource_name_stub_primary}-${var.this_slug}-ingress-sg"
  vpc_id      = module.vpc_primary.vpc_id

  tags = { Name = "${local.resource_name_stub_primary}-${var.this_slug}-ingress-sg" }
}

module "sg_ingress_rules_primary" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.3.0"
  providers = { aws = aws.this }

  create_sg         = false
  security_group_id = module.sg_ingress_primary.security_group_id

  ingress_with_cidr_blocks = var.create_vpc_public_subnets ? [
    {
      description = "allow http from ipv4 internet"
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "allow https from ipv4 internet"
      rule        = "https-443-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    ] : var.create_failover_region_networking ? [
    {
      description = "allow all from client vpn"
      rule        = "all-all"
      cidr_blocks = "${var.vpc_cidr_infrastructure.client_vpn_prd_primary},${var.vpc_cidr_infrastructure.client_vpn_prd_failover},${var.vpc_cidr_infrastructure.client_vpn_stg_primary},${var.vpc_cidr_infrastructure.client_vpn_stg_failover}"
    },
    ] : [
    {
      description = "allow all from client vpn"
      rule        = "all-all"
      cidr_blocks = "${var.vpc_cidr_infrastructure.client_vpn_prd_primary},${var.vpc_cidr_infrastructure.client_vpn_stg_primary}"
    },
  ]

  ingress_with_ipv6_cidr_blocks = var.create_vpc_public_subnets ? [
    {
      description = "allow http from ipv6 internet"
      rule        = "http-80-tcp"
      cidr_blocks = "::/0"
    },
    {
      description = "allow https from ipv6 internet"
      rule        = "https-443-tcp"
      cidr_blocks = "::/0"
    },
  ] : []

  egress_with_source_security_group_id = [
    {
      description              = "allow all traffic to main sg"
      rule                     = "all-all"
      source_security_group_id = module.sg_main_primary.security_group_id
    },
  ]
}