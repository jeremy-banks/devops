resource "aws_ec2_tag" "tgw_identity" {
  provider    = aws.identity

  count = 1

  resource_id = aws_ec2_transit_gateway.tgw_primary[0].id
  key         = "Name"
  value       = "${local.resource_name_stub_primary}-${local.this_slug}-tgw"
}

resource "aws_ec2_tag" "tgw_log_archive" {
  provider    = aws.log_archive

  count = 1

  resource_id = aws_ec2_transit_gateway.tgw_primary[0].id
  key         = "Name"
  value       = "${local.resource_name_stub_primary}-${local.this_slug}-tgw"
}

resource "aws_ec2_tag" "tgw_security_tooling" {
  provider    = aws.security_tooling

  count = 1

  resource_id = aws_ec2_transit_gateway.tgw_primary[0].id
  key         = "Name"
  value       = "${local.resource_name_stub_primary}-${local.this_slug}-tgw"
}

resource "aws_ec2_tag" "tgw_identity_failover" {
  provider    = aws.identity_failover

  count = local.create_failover_region != "" ? 1 : 0

  resource_id = aws_ec2_transit_gateway.tgw_failover[0].id
  key         = "Name"
  value       = "${local.resource_name_stub_failover}-${local.this_slug}-tgw"
}

resource "aws_ec2_tag" "tgw_log_archive_failover" {
  provider    = aws.log_archive_failover

  count = local.create_failover_region != "" ? 1 : 0

  resource_id = aws_ec2_transit_gateway.tgw_failover[0].id
  key         = "Name"
  value       = "${local.resource_name_stub_failover}-${local.this_slug}-tgw"
}

resource "aws_ec2_tag" "tgw_security_tooling_failover" {
  provider    = aws.security_tooling_failover

  count = local.create_failover_region != "" ? 1 : 0

  resource_id = aws_ec2_transit_gateway.tgw_failover[0].id
  key         = "Name"
  value       = "${local.resource_name_stub_failover}-${local.this_slug}-tgw"
}