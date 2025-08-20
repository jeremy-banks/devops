provider "aws" {
  alias   = "this"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.product_a_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "this_failover"
  profile = var.cli_profile_name
  region  = var.region_failover.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id.product_a_prd}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "this_prd"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id[local.this_prd]}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "this_stg"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id[local.this_stg]}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "this_tst"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id[local.this_tst]}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

provider "aws" {
  alias   = "this_dev"
  profile = var.cli_profile_name
  region  = var.region_primary.full
  assume_role { role_arn = "arn:aws:iam::${var.account_id[local.this_dev]}:role/${var.provider_role_name}" }
  default_tags { tags = local.default_tags_map }
}

data "aws_caller_identity" "this" { provider = aws.this }

data "aws_ec2_transit_gateway" "tgw_primary" {
  provider = aws.network_prd

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
  provider = aws.network_prd_failover

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
  provider = aws.network_prd

  filter {
    name   = "tag:Name"
    values = ["vpc-central-inspection-tgw-attach-primary"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_ec2_transit_gateway_route_table" "tgw_pre_central_inspection_primary" {
  provider = aws.network_prd

  filter {
    name   = "tag:Name"
    values = ["tgw-pre-inspection-primary"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_ec2_transit_gateway_route_table" "tgw_post_central_inspection_primary" {
  provider = aws.network_prd

  filter {
    name   = "tag:Name"
    values = ["tgw-post-inspection-primary"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_ec2_transit_gateway_peering_attachment" "tgw_peer_primary" {
  provider = aws.network_prd

  count = var.create_failover_region ? 1 : 0

  filter {
    name   = "tag:Name"
    values = ["tgw-peer-accepter-primary"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_ec2_transit_gateway_vpc_attachment" "tgw_post_inspection_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region ? 1 : 0

  filter {
    name   = "tag:Name"
    values = ["vpc-central-inspection-tgw-attach-failover"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_ec2_transit_gateway_route_table" "tgw_pre_inspection_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region ? 1 : 0

  filter {
    name   = "tag:Name"
    values = ["tgw-pre-inspection-failover"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_ec2_transit_gateway_route_table" "tgw_post_inspection_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region ? 1 : 0

  filter {
    name   = "tag:Name"
    values = ["tgw-post-inspection-failover"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_ec2_transit_gateway_peering_attachment" "tgw_peer_failover" {
  provider = aws.network_prd_failover

  count = var.create_failover_region ? 1 : 0

  filter {
    name   = "tag:Name"
    values = ["tgw-peer-requester-failover"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

locals {
  vpc_cidr_primary  = var.vpc_cidr_infrastructure.product_a_prd_primary
  vpc_cidr_failover = var.vpc_cidr_infrastructure.product_a_prd_failover
}