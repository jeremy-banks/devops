resource "aws_ram_resource_share" "vpc_primary" {
  provider = aws.network

  name                      = "${local.resource_name_stub}-${var.region.primary_short}-${local.this_slug}-vpc"
  allow_external_principals = false
}

resource "aws_ram_principal_association" "vpc_primary_infrastructure_ou" {
  provider = aws.network

  principal          = data.aws_organizations_organizational_unit.infrastructure.arn
  resource_share_arn = aws_ram_resource_share.vpc_primary.arn
}

resource "aws_ram_principal_association" "vpc_primary_security_ou" {
  provider = aws.network

  principal          = data.aws_organizations_organizational_unit.security.arn
  resource_share_arn = aws_ram_resource_share.vpc_primary.arn
}

resource "aws_ram_resource_association" "vpc_primary_subnets" {
  provider = aws.network

  count = var.vpc_enabled ? length(flatten(concat(
    module.vpc_primary[0].public_subnet_arns,
    module.vpc_primary[0].private_subnet_arns
  ))) : 0
  
  resource_arn = flatten(concat(
    module.vpc_primary[0].public_subnet_arns,
    module.vpc_primary[0].private_subnet_arns
  ))[count.index]
  
  resource_share_arn = aws_ram_resource_share.vpc_primary.id
}

resource "aws_ram_resource_share" "vpc_failover" {
  provider = aws.network_failover

  name                      = "${local.resource_name_stub}-${var.region.failover_short}-${local.this_slug}-vpc"
  allow_external_principals = false
}

resource "aws_ram_principal_association" "vpc_failover_infrastructure_ou" {
  provider = aws.network_failover

  principal          = data.aws_organizations_organizational_unit.infrastructure.arn
  resource_share_arn = aws_ram_resource_share.vpc_failover.arn
}

resource "aws_ram_principal_association" "vpc_failover_security_ou" {
  provider = aws.network_failover

  principal          = data.aws_organizations_organizational_unit.security.arn
  resource_share_arn = aws_ram_resource_share.vpc_failover.arn
}

resource "aws_ram_resource_association" "vpc_failover_subnets" {
  provider = aws.network_failover

  count = var.vpc_enabled && var.vpc_failover_enabled ? length(flatten(concat(
    module.vpc_failover[0].public_subnet_arns,
    module.vpc_failover[0].private_subnet_arns
  ))) : 0
  
  resource_arn = flatten(concat(
    module.vpc_failover[0].public_subnet_arns,
    module.vpc_failover[0].private_subnet_arns
  ))[count.index]
  
  resource_share_arn = aws_ram_resource_share.vpc_failover.id
}