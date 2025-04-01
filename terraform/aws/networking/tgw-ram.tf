resource "aws_ram_resource_share" "tgw_primary" {
  provider = aws.network_prd

  name                      = "tgw-${var.region.primary_short}"
  allow_external_principals = false
}

resource "aws_ram_resource_association" "tgw_primary_ram" {
  provider = aws.network_prd

  resource_arn       = aws_ec2_transit_gateway.tgw_primary.arn
  resource_share_arn = aws_ram_resource_share.tgw_primary.arn
}

resource "aws_ram_principal_association" "tgw_primary_ous" {
  provider = aws.network_prd

  count = length(data.aws_organizations_organizational_units.top_level.children[*].arn)

  principal          = data.aws_organizations_organizational_units.top_level.children[count.index].arn
  resource_share_arn = aws_ram_resource_share.tgw_primary.arn
}

resource "aws_ram_resource_share" "tgw_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region ? 1 : 0

  name                      = "tgw-${var.region.failover_short}"
  allow_external_principals = false
}

resource "aws_ram_resource_association" "tgw_failover_ram" {
  provider = aws.network_prd_failover

  count = var.create_failover_region ? 1 : 0

  resource_arn       = aws_ec2_transit_gateway.tgw_failover[0].arn
  resource_share_arn = aws_ram_resource_share.tgw_failover[0].arn
}

resource "aws_ram_principal_association" "tgw_failover_ous" {
  provider = aws.network_prd_failover

  count = var.create_failover_region && length(data.aws_organizations_organizational_units.top_level.children[*].arn) > 0 ? length(data.aws_organizations_organizational_units.top_level.children[*].arn) : 0

  principal          = data.aws_organizations_organizational_units.top_level.children[count.index].arn
  resource_share_arn = aws_ram_resource_share.tgw_failover[0].arn
}