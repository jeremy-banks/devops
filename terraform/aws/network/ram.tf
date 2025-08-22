resource "aws_ram_resource_share" "primary" {
  provider = aws.network_prd

  name                      = "${local.resource_name_primary}-ram"
  allow_external_principals = false
}

resource "aws_ram_resource_association" "ram_tgw_primary" {
  provider = aws.network_prd

  resource_arn       = aws_ec2_transit_gateway.tgw_primary.arn
  resource_share_arn = aws_ram_resource_share.primary.arn
}

resource "aws_ram_principal_association" "ram_ou_infrastructure_primary" {
  provider = aws.network_prd

  principal          = data.aws_organizations_organizational_unit.infrastructure.arn
  resource_share_arn = aws_ram_resource_share.primary.arn
}

resource "aws_ram_principal_association" "ram_ou_security_primary" {
  provider = aws.network_prd

  principal          = data.aws_organizations_organizational_unit.security.arn
  resource_share_arn = aws_ram_resource_share.primary.arn
}

resource "aws_ram_principal_association" "ram_ou_workloads_primary" {
  provider = aws.network_prd

  principal          = data.aws_organizations_organizational_unit.workloads.arn
  resource_share_arn = aws_ram_resource_share.primary.arn
}

resource "aws_ram_resource_share" "failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region_network ? 1 : 0

  name                      = "${local.resource_name_failover}-ram"
  allow_external_principals = false
}

resource "aws_ram_resource_association" "ram_tgw_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region_network ? 1 : 0

  resource_arn       = aws_ec2_transit_gateway.tgw_failover[0].arn
  resource_share_arn = aws_ram_resource_share.failover[0].arn
}

resource "aws_ram_principal_association" "ram_ou_infrastructure_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region_network ? 1 : 0

  principal          = data.aws_organizations_organizational_unit.infrastructure.arn
  resource_share_arn = aws_ram_resource_share.failover[0].arn
}

resource "aws_ram_principal_association" "ram_ou_security_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region_network ? 1 : 0

  principal          = data.aws_organizations_organizational_unit.security.arn
  resource_share_arn = aws_ram_resource_share.failover[0].arn
}

resource "aws_ram_principal_association" "ram_ou_workloads_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region_network ? 1 : 0

  principal          = data.aws_organizations_organizational_unit.workloads.arn
  resource_share_arn = aws_ram_resource_share.failover[0].arn
}