# kms
module "kms_primary" {
  source  = "terraform-aws-modules/kms/aws"
  version = "2.1.0"

  providers = { aws = aws.project_demo_nonprod }

  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = true

  aliases = ["${local.resource_name_env_stub}-primary"]

  policy = data.aws_iam_policy_document.kms.json
}

module "kms_replica" {
  source  = "terraform-aws-modules/kms/aws"
  version = "2.1.0"

  providers = { aws = aws.project_demo_nonprod_failover }

  deletion_window_in_days = 30
  create_replica          = true
  primary_key_arn         = module.kms_primary.key_arn

  aliases = ["${local.resource_name_env_stub}-replica"]

  policy = data.aws_iam_policy_document.kms.json
}

data "aws_caller_identity" "project_demo_nonprod" { provider = aws.project_demo_nonprod }

data "aws_iam_policy_document" "kms"  {
  statement {
    sid    = "Default"

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.project_demo_nonprod.account_id}:root"]
    }

    actions   = ["kms:*"]

    resources = ["*"]
  }

  statement {
    sid    = "Allow use of the key"

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.project_demo_nonprod.account_id}:root"]
    }

    actions   = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = ["${data.aws_caller_identity.project_demo_nonprod.account_id}"]
    }
  }

  statement {
    sid    = "Allow attachment of persistent resources"

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.project_demo_nonprod.account_id}:root"]
    }

    actions   = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant",
    ]

    resources = ["*"]
  
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = ["${data.aws_caller_identity.project_demo_nonprod.account_id}"]
    }
  }
}

#acm
module "acm_wildcard_cert" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.0.0"

  providers = { aws = aws.project_demo_nonprod }

  domain_name = var.company_domain
  subject_alternative_names = ["*.${var.company_domain}"]

  create_route53_records  = false
  validation_method       = "DNS"
  validation_record_fqdns = module.acm_dns_records.validation_route53_record_fqdns
}

data "aws_route53_zone" "company_domain" {
  name         = "${var.company_domain}"
  private_zone = false

  provider = aws.network
}

module "acm_dns_records" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.0.0"

  providers = { aws = aws.network }

  create_certificate          = false
  create_route53_records_only = true
  validation_method           = "DNS"

  zone_id               = data.aws_route53_zone.company_domain.zone_id
  distinct_domain_names = module.acm_wildcard_cert.distinct_domain_names

  acm_certificate_domain_validation_options = module.acm_wildcard_cert.acm_certificate_domain_validation_options
}

#vpc
resource "aws_eip" "vpc_nat_primary" {
  provider = aws.project_demo_nonprod

  count = 2
  domain = "vpc"
  tags = { "Name" = "${local.resource_name_env_stub}-primary-${count.index}" }

  lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE
}

module "vpc_primary" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.4.0"

  providers = { aws = aws.project_demo_nonprod }

  reuse_nat_ips = true
  external_nat_ip_ids = aws_eip.vpc_nat_primary[*].id

  name = "${local.resource_name_env_stub}-vpc-primary"
  public_subnet_suffix = "pub"
  private_subnet_suffix = "pvt"
  cidr = "${var.vpc_prefixes.project_demo_nonprod.primary}0.0/16"

  azs = var.availability_zones.primary
  public_subnets = [
    "${var.vpc_prefixes.project_demo_nonprod.primary}${var.vpc_suffixes.subnet_public_a}",
    "${var.vpc_prefixes.project_demo_nonprod.primary}${var.vpc_suffixes.subnet_public_b}",
  ]
  private_subnets = [
    "${var.vpc_prefixes.project_demo_nonprod.primary}${var.vpc_suffixes.subnet_private_a}",
    "${var.vpc_prefixes.project_demo_nonprod.primary}${var.vpc_suffixes.subnet_private_b}",
  ]

  public_subnet_tags = { "kubernetes.io/role/elb" = 1 }
  private_subnet_tags = { "kubernetes.io/role/internal-elb" = 1 }
  vpc_tags = {
    "${local.resource_name_env_stub}-cluster-primary-blue"   = "shared"
    "${local.resource_name_env_stub}-cluster-primary-green"  = "shared"
  }

  manage_default_security_group = false #never use default security groups

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_dhcp_options = true
  dhcp_options_domain_name_servers = concat(["${var.vpc_prefixes.project_demo_nonprod.primary}0.2"], local.vpc_domain_name_servers)
  dhcp_options_ntp_servers = local.vpc_ntp_servers
}

module "vpc_primary_main_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  providers = { aws = aws.project_demo_nonprod }

  name        = "${local.resource_name_env_stub}-main"
  description = "main security group for ${local.resource_name_env_stub}"
  vpc_id      = module.vpc_primary.vpc_id

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

module "vpc_primary_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.4.0"

  providers = { aws = aws.project_demo_nonprod }

  vpc_id             = module.vpc_primary.vpc_id
  security_group_ids = [module.vpc_primary_main_sg.security_group_id]

  endpoints = {
    s3 = {
      # interface endpoint
      service             = "s3"
      service_type  = "Gateway"
      # private_dns_enabled = true
      # security_group_ids  = [module.vpc_primary_main_sg.security_group_id]
      subnet_ids = module.vpc_primary.private_subnets
      route_table_ids = flatten([module.vpc_primary.private_route_table_ids, module.vpc_primary.public_route_table_ids])
      tags                = { Name = "${local.resource_name_env_stub}-s3-vpc-endpoint-primary" }
    },
    rds = {
      # interface endpoint
      service             = "rds"
      # service_type  = "Gateway"
      private_dns_enabled = true
      # security_group_ids  = [module.vpc_primary_main_sg.security_group_id]
      subnet_ids = module.vpc_primary.private_subnets
      # route_table_ids = flatten([module.vpc_primary.private_route_table_ids, module.vpc_primary.public_route_table_ids])
      tags                = { Name = "${local.resource_name_env_stub}-rds-endpoint-primary" }
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

resource "aws_eip" "vpc_nat_failover" {
  provider = aws.project_demo_nonprod_failover

  count = 2
  domain = "vpc"
  tags = { "Name" = "${local.resource_name_env_stub}-failover-${count.index}" }

  lifecycle { prevent_destroy = true } # YOU NEVER WANT TO DELETE THESE
}

module "vpc_failover" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.4.0"

  providers = { aws = aws.project_demo_nonprod_failover }

  reuse_nat_ips = true
  external_nat_ip_ids = aws_eip.vpc_nat_failover[*].id

  name = "${local.resource_name_env_stub}-vpc-failover"
  public_subnet_suffix = "pub"
  private_subnet_suffix = "pvt"
  cidr = "${var.vpc_prefixes.project_demo_nonprod.failover}0.0/16"

  azs = var.availability_zones.failover
  public_subnets = [
    "${var.vpc_prefixes.project_demo_nonprod.failover}${var.vpc_suffixes.subnet_public_a}",
    "${var.vpc_prefixes.project_demo_nonprod.failover}${var.vpc_suffixes.subnet_public_b}",
  ]
  private_subnets = [
    "${var.vpc_prefixes.project_demo_nonprod.failover}${var.vpc_suffixes.subnet_private_a}",
    "${var.vpc_prefixes.project_demo_nonprod.failover}${var.vpc_suffixes.subnet_private_b}",
  ]

  public_subnet_tags = { "kubernetes.io/role/elb" = 1 }
  private_subnet_tags = { "kubernetes.io/role/internal-elb" = 1 }
  vpc_tags = {
    "${local.resource_name_env_stub}-cluster-failover-blue"   = "shared"
    "${local.resource_name_env_stub}-cluster-failover-green"  = "shared"
  }

  manage_default_security_group = false #never use default security groups

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_dhcp_options = true
  dhcp_options_domain_name_servers = concat(["${var.vpc_prefixes.project_demo_nonprod.failover}0.2"], local.vpc_domain_name_servers)
  dhcp_options_ntp_servers = local.vpc_ntp_servers
}


module "vpc_failover_main_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  providers = { aws = aws.project_demo_nonprod_failover }

  name        = "${local.resource_name_env_stub}-main"
  description = "main security group for ${local.resource_name_env_stub}"
  vpc_id      = module.vpc_failover.vpc_id

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

module "vpc_failover_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.4.0"

  providers = { aws = aws.project_demo_nonprod_failover }

  vpc_id             = module.vpc_failover.vpc_id
  security_group_ids = [module.vpc_failover_main_sg.security_group_id]

  endpoints = {
    s3 = {
      # interface endpoint
      service             = "s3"
      service_type  = "Gateway"
      # private_dns_enabled = true
      # security_group_ids  = [module.vpc_failover_main_sg.security_group_id]
      subnet_ids = module.vpc_failover.private_subnets
      route_table_ids = flatten([module.vpc_failover.private_route_table_ids, module.vpc_failover.public_route_table_ids])
      tags                = { Name = "${local.resource_name_env_stub}-s3-vpc-endpoint-failover" }
    },
    rds = {
      # interface endpoint
      service             = "rds"
      # service_type  = "Gateway"
      private_dns_enabled = true
      # security_group_ids  = [module.vpc_failover_main_sg.security_group_id]
      subnet_ids = module.vpc_failover.private_subnets
      # route_table_ids = flatten([module.vpc_failover.private_route_table_ids, module.vpc_failover.public_route_table_ids])
      tags                = { Name = "${local.resource_name_env_stub}-rds-endpoint-failover" }
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

#iam