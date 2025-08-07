locals {
  unique_id = substr(sha256("foo${data.aws_caller_identity.this.account_id}"), 0, 8)

  # this_workload = join("_", [var.this_slug, var.deployment_environment])
}

data "aws_caller_identity" "this" { provider = aws.this }

data "aws_ec2_transit_gateway" "tgw_primary" {
  provider = aws.networking_prd

  filter {
    name   = "options.amazon-side-asn"
    values = [var.tgw_asn.primary]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_ec2_transit_gateway" "tgw_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  filter {
    name   = "options.amazon-side-asn"
    values = [var.tgw_asn.failover]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_ec2_transit_gateway_vpc_attachment" "tgw_post_central_inspection_primary" {
  provider = aws.networking_prd

  filter {
    name   = "tag:Name"
    values = ["${local.resource_name_stub_primary}-network-tgw-attach-central-inspection-vpc"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_ec2_transit_gateway_route_table" "tgw_pre_central_inspection_primary" {
  provider = aws.networking_prd

  filter {
    name   = "tag:Name"
    values = ["${local.resource_name_stub_primary}-network-tgw-pre-inspection"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_ec2_transit_gateway_route_table" "tgw_post_central_inspection_primary" {
  provider = aws.networking_prd

  filter {
    name   = "tag:Name"
    values = ["${local.resource_name_stub_primary}-network-tgw-post-inspection"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_ec2_transit_gateway_peering_attachment" "tgw_peer_primary" {
  provider = aws.networking_prd

  count = var.create_failover_region ? 1 : 0

  filter {
    name   = "tag:Name"
    values = ["${local.resource_name_stub_primary}-network-tgw-peer-accepter"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_ec2_transit_gateway_vpc_attachment" "tgw_post_inspection_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  filter {
    name   = "tag:Name"
    values = ["${local.resource_name_stub_failover}-network-tgw-attach-central-inspection-vpc"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_ec2_transit_gateway_route_table" "tgw_pre_inspection_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  filter {
    name   = "tag:Name"
    values = ["${local.resource_name_stub_failover}-network-tgw-pre-inspection"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_ec2_transit_gateway_route_table" "tgw_post_inspection_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  filter {
    name   = "tag:Name"
    values = ["${local.resource_name_stub_failover}-network-tgw-post-inspection"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_ec2_transit_gateway_peering_attachment" "tgw_peer_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  filter {
    name   = "tag:Name"
    values = ["${local.resource_name_stub_failover}-network-tgw-peer-requester"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}