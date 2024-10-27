resource "aws_ram_resource_share" "network_primary" {
  provider = aws.network

  name                      = "${local.vpc_name_primary}"
  allow_external_principals = false
}

resource "aws_ram_principal_association" "network_primary_infrastructure_ou" {
  provider = aws.network

  principal          = data.aws_organizations_organizational_unit.infrastructure.arn
  resource_share_arn = aws_ram_resource_share.network_primary.arn
}

resource "aws_ram_principal_association" "network_primary_security_ou" {
  provider = aws.network

  principal          = data.aws_organizations_organizational_unit.security.arn
  resource_share_arn = aws_ram_resource_share.network_primary.arn
}

resource "aws_ram_resource_association" "vpc_primary_subnets" {
  provider = aws.network

  count = length(flatten(concat(
    module.vpc_primary[0].public_subnet_arns,
    module.vpc_primary[0].private_subnet_arns
  )))
  
  resource_arn = flatten(concat(
    module.vpc_primary[0].public_subnet_arns,
    module.vpc_primary[0].private_subnet_arns
  ))[count.index]
  
  resource_share_arn = aws_ram_resource_share.network_primary.id
}

resource "aws_ram_resource_share" "network_failover" {
  provider = aws.network_failover

  name                      = "${local.vpc_name_failover}"
  allow_external_principals = false
}

resource "aws_ram_principal_association" "network_failover_infrastructure_ou" {
  provider = aws.network_failover

  principal          = data.aws_organizations_organizational_unit.infrastructure.arn
  resource_share_arn = aws_ram_resource_share.network_failover.arn
}

resource "aws_ram_principal_association" "network_failover_security_ou" {
  provider = aws.network_failover

  principal          = data.aws_organizations_organizational_unit.security.arn
  resource_share_arn = aws_ram_resource_share.network_failover.arn
}

resource "aws_ram_resource_association" "vpc_failover_subnets" {
  provider = aws.network_failover

  count = var.vpc_failover_enabled ? length(flatten(concat(
    module.vpc_failover[0].public_subnet_arns,
    module.vpc_failover[0].private_subnet_arns
  ))) : 0
  
  resource_arn = flatten(concat(
    module.vpc_failover[0].public_subnet_arns,
    module.vpc_failover[0].private_subnet_arns
  ))[count.index]
  
  resource_share_arn = aws_ram_resource_share.network_failover.id
}