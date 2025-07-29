resource "aws_ram_resource_share" "primary" {
  provider = aws.networking_prd

  name                      = "${local.resource_name_stub_primary}-${var.this_slug}"
  allow_external_principals = false
}

resource "aws_ram_resource_association" "ram_tgw_primary" {
  provider = aws.networking_prd

  resource_arn       = aws_ec2_transit_gateway.tgw_primary.arn
  resource_share_arn = aws_ram_resource_share.primary.arn
}

resource "aws_ram_resource_association" "ram_central_ingress_subnets_primary" {
  provider = aws.networking_prd

  count = length(module.vpc_central_ingress_primary.public_subnet_arns)

  resource_arn       = module.vpc_central_ingress_primary.public_subnet_arns[count.index]
  resource_share_arn = aws_ram_resource_share.primary.arn
}

data "aws_organizations_organizational_unit" "infrastructure" {
  parent_id = data.aws_organizations_organization.this.roots[0].id
  name      = "infrastructure"
}

data "aws_organizations_organizational_unit" "security" {
  parent_id = data.aws_organizations_organization.this.roots[0].id
  name      = "security"
}

data "aws_organizations_organizational_unit" "workloads" {
  parent_id = data.aws_organizations_organization.this.roots[0].id
  name      = "workloads"
}

resource "aws_ram_principal_association" "ram_ou_infrastructure_primary" {
  provider = aws.networking_prd

  principal          = data.aws_organizations_organizational_unit.infrastructure.arn
  resource_share_arn = aws_ram_resource_share.primary.arn
}

resource "aws_ram_principal_association" "ram_ou_security_primary" {
  provider = aws.networking_prd

  principal          = data.aws_organizations_organizational_unit.security.arn
  resource_share_arn = aws_ram_resource_share.primary.arn
}

resource "aws_ram_principal_association" "ram_ou_workloads_primary" {
  provider = aws.networking_prd

  principal          = data.aws_organizations_organizational_unit.workloads.arn
  resource_share_arn = aws_ram_resource_share.primary.arn
}

resource "aws_ram_resource_share" "failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  name                      = "${local.resource_name_stub_failover}-${var.this_slug}"
  allow_external_principals = false
}

resource "aws_ram_resource_association" "ram_tgw_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  resource_arn       = aws_ec2_transit_gateway.tgw_failover[0].arn
  resource_share_arn = aws_ram_resource_share.failover[0].arn
}

resource "aws_ram_resource_association" "ram_central_ingress_subnets_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? length(module.vpc_central_ingress_failover[0].public_subnet_arns) : 0

  resource_arn       = module.vpc_central_ingress_failover[0].public_subnet_arns[count.index]
  resource_share_arn = aws_ram_resource_share.failover[0].arn
}

resource "aws_ram_principal_association" "ram_ou_infrastructure_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  principal          = data.aws_organizations_organizational_unit.infrastructure.arn
  resource_share_arn = aws_ram_resource_share.failover[0].arn
}

resource "aws_ram_principal_association" "ram_ou_security_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  principal          = data.aws_organizations_organizational_unit.security.arn
  resource_share_arn = aws_ram_resource_share.failover[0].arn
}

resource "aws_ram_principal_association" "ram_ou_workloads_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  principal          = data.aws_organizations_organizational_unit.workloads.arn
  resource_share_arn = aws_ram_resource_share.failover[0].arn
}