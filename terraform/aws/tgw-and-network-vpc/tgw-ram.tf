resource "aws_ram_resource_share" "tgw_primary" {
  provider = aws.network

  count = local.vpc_cidr_primary != "" ? 1 : 0

  name                      = "${local.resource_name_stub_primary}-${local.this_slug}-tgw"
  allow_external_principals = false
}

resource "aws_ram_resource_association" "tgw_primary" {
  provider = aws.network

  count = local.vpc_cidr_primary != "" ? 1 : 0

  resource_arn       = aws_ec2_transit_gateway.tgw_primary[0].arn
  resource_share_arn = aws_ram_resource_share.tgw_primary[0].arn
}

resource "aws_ram_principal_association" "tgw_primary_ou_infrastructure" {
  provider = aws.network

  count = local.vpc_cidr_primary != "" ? 1 : 0

  principal          = data.aws_organizations_organizational_unit.infrastructure.arn
  resource_share_arn = aws_ram_resource_share.tgw_primary[0].arn
}

resource "aws_ram_principal_association" "tgw_primary_ou_security" {
  provider = aws.network

  count = local.vpc_cidr_primary != "" ? 1 : 0

  principal          = data.aws_organizations_organizational_unit.security.arn
  resource_share_arn = aws_ram_resource_share.tgw_primary[0].arn
}

resource "aws_ram_principal_association" "tgw_primary_ou_workloads" {
  provider = aws.network

  count = local.vpc_cidr_primary != "" ? 1 : 0

  principal          = data.aws_organizations_organizational_unit.workloads.arn
  resource_share_arn = aws_ram_resource_share.tgw_primary[0].arn
}

resource "aws_ram_resource_share" "tgw_failover" {
  provider = aws.network_failover

  count = local.create_failover_region ? 1 : 0

  name                      = "${local.resource_name_stub_failover}-${local.this_slug}-tgw"
  allow_external_principals = false
}

resource "aws_ram_resource_association" "tgw_failover" {
  provider = aws.network_failover

  count = local.create_failover_region ? 1 : 0

  resource_arn       = aws_ec2_transit_gateway.tgw_failover[0].arn
  resource_share_arn = aws_ram_resource_share.tgw_failover[0].arn
}

resource "aws_ram_principal_association" "tgw_failover_ou_infrastructure" {
  provider = aws.network_failover

  count = local.create_failover_region ? 1 : 0

  principal          = data.aws_organizations_organizational_unit.infrastructure.arn
  resource_share_arn = aws_ram_resource_share.tgw_failover[0].arn
}

resource "aws_ram_principal_association" "tgw_failover_ou_security" {
  provider = aws.network_failover

  count = local.create_failover_region ? 1 : 0

  principal          = data.aws_organizations_organizational_unit.security.arn
  resource_share_arn = aws_ram_resource_share.tgw_failover[0].arn
}

resource "aws_ram_principal_association" "tgw_failover_ou_workloads" {
  provider = aws.network_failover

  count = local.create_failover_region ? 1 : 0

  principal          = data.aws_organizations_organizational_unit.workloads.arn
  resource_share_arn = aws_ram_resource_share.tgw_failover[0].arn
}