resource "aws_ram_resource_share" "primary" {
  provider = aws.network

  name                      = "${local.resource_name_stub}-${var.region.failover_short}-ram-vpc"
  allow_external_principals = false
}

resource "aws_ram_principal_association" "primary" {
  provider = aws.network

  principal          = data.aws_organizations_organization.current.arn
  resource_share_arn = aws_ram_resource_share.primary.arn
}

resource "aws_ram_resource_association" "primary_pub" {
  provider = aws.network

  count = length(module.vpc_primary.public_subnet_arns)
  resource_arn       = module.vpc_primary.public_subnet_arns[count.index]
  resource_share_arn = aws_ram_resource_share.primary.arn
}

resource "aws_ram_resource_association" "primary_pvt" {
  provider = aws.network

  count = length(module.vpc_primary.private_subnet_arns)
  resource_arn       = module.vpc_primary.private_subnet_arns[count.index]
  resource_share_arn = aws_ram_resource_share.primary.arn
}

resource "aws_ram_resource_share" "failover" {
  provider = aws.network_failover

  name  = "${local.resource_name_stub}-${var.region.failover_short}-ram-vpc"
  allow_external_principals = false
}

resource "aws_ram_principal_association" "failover" {
  provider = aws.network_failover

  principal          = data.aws_organizations_organization.current.arn
  resource_share_arn = aws_ram_resource_share.failover.arn
}

resource "aws_ram_resource_association" "failover_pub" {
  provider = aws.network_failover

  count = length(module.vpc_failover.public_subnet_arns)
  resource_arn       = module.vpc_failover.public_subnet_arns[count.index]
  resource_share_arn = aws_ram_resource_share.failover.arn
}

resource "aws_ram_resource_association" "failover_pvt" {
  provider = aws.network_failover

  count = length(module.vpc_failover.private_subnet_arns)
  resource_arn       = module.vpc_failover.private_subnet_arns[count.index]
  resource_share_arn = aws_ram_resource_share.failover.arn
}