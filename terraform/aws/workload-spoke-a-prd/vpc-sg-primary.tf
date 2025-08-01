module "sg_main_primary" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.3.0"
  providers = { aws = aws.workload_spoke_a_prd }

  name        = "${local.resource_name_stub_primary}-${var.this_slug}-main-sg"
  description = "${local.resource_name_stub_primary}-${var.this_slug}-main-sg"
  vpc_id      = module.vpc_primary.vpc_id

  tags = { Name = "${local.resource_name_stub_primary}-${var.this_slug}-main-sg" }
}

module "sg_main_rules_primary" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.3.0"
  providers = { aws = aws.workload_spoke_a_prd }

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

  ingress_with_source_security_group_id = var.create_vpc_public_subnets ? [
    {
      description              = "allow all from ingress security group"
      rule                     = "all-all"
      source_security_group_id = module.sg_ingress_primary[0].security_group_id
    },
  ] : []

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
}

module "sg_ingress_primary" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.3.0"
  providers = { aws = aws.workload_spoke_a_prd }

  count = var.create_vpc_public_subnets ? 1 : 0

  name        = "${local.resource_name_stub_primary}-${var.this_slug}-ingress-sg"
  description = "${local.resource_name_stub_primary}-${var.this_slug}-ingress-sg"
  vpc_id      = module.vpc_primary.vpc_id

  tags = { Name = "${local.resource_name_stub_primary}-${var.this_slug}-ingress-sg" }
}

module "sg_ingress_rules_primary" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.3.0"
  providers = { aws = aws.workload_spoke_a_prd }

  count = var.create_vpc_public_subnets ? 1 : 0

  create_sg         = false
  security_group_id = module.sg_ingress_primary[0].security_group_id

  # ingress_rules            = ["http-80-tcp", "https-443-tcp", "ssh-tcp"]
  # ingress_cidr_blocks      = ["0.0.0.0/0"]
  # ingress_ipv6_cidr_blocks = ["::/0"]


  ingress_with_cidr_blocks = [
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
  ]

  ingress_with_ipv6_cidr_blocks = [
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
  ]

  egress_with_source_security_group_id = [
    {
      description              = "allow all traffic to main security group"
      rule                     = "all-all"
      source_security_group_id = module.sg_main_primary.security_group_id
    },
  ]
}