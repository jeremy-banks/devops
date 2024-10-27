resource "aws_ec2_tag" "tgw_identity" {
  provider    = aws.identity

  resource_id = aws_ec2_transit_gateway.tgw_primary.id
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.primary_short}-${local.this_slug}-tgw"
}

resource "aws_ec2_tag" "tgw_log_archive" {
  provider    = aws.log_archive

  resource_id = aws_ec2_transit_gateway.tgw_primary.id
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.primary_short}-${local.this_slug}-tgw"
}

resource "aws_ec2_tag" "tgw_security_tooling" {
  provider    = aws.security_tooling

  resource_id = aws_ec2_transit_gateway.tgw_primary.id
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.primary_short}-${local.this_slug}-tgw"
}

resource "aws_ec2_tag" "tgw_identity_failover" {
  provider    = aws.identity_failover

  count = var.vpc_failover_enabled ? 1 : 0

  resource_id = aws_ec2_transit_gateway.tgw_failover[0].id
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.failover_short}-${local.this_slug}-tgw"
}

resource "aws_ec2_tag" "tgw_log_archive_failover" {
  provider    = aws.log_archive_failover

  count = var.vpc_failover_enabled ? 1 : 0

  resource_id = aws_ec2_transit_gateway.tgw_failover[0].id
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.failover_short}-${local.this_slug}-tgw"
}

resource "aws_ec2_tag" "tgw_security_tooling_failover" {
  provider    = aws.security_tooling_failover

  count = var.vpc_failover_enabled ? 1 : 0

  resource_id = aws_ec2_transit_gateway.tgw_failover[0].id
  key         = "Name"
  value       = "${local.resource_name_stub}-${var.region.failover_short}-${local.this_slug}-tgw"
}