data "aws_caller_identity" "networking" { provider = aws.networking_prd }

locals {
  current_time = timestamp()
  test_start   = formatdate("YYYYMMDDhhmmss", timeadd(local.current_time, "60s"))
  test_stop    = formatdate("YYYYMMDDhhmmss", timeadd(local.current_time, "120s"))
}

data "aws_ami" "amazon_linux_primary" {
  provider = aws.networking_prd

  filter {
    name   = "image-id"
    values = ["ami-03887e047a13b89aa"]
  }

  #   most_recent = true
  #   owners      = ["amazon"]

  #   filter {
  #     name   = "name"
  #     values = ["amzn2-ami-hvm-*-arm64-gp2"]
  #   }
}

data "aws_ami" "amazon_linux_failover" {
  provider = aws.networking_prd_failover

  filter {
    name   = "image-id"
    values = ["ami-0f79869174a04921d"]
  }

  #   most_recent = true
  #   owners      = ["amazon"]

  #   filter {
  #     name   = "name"
  #     values = ["amzn2-ami-hvm-*-arm64-gp2"]
  #   }
}

#keypairs
data "aws_key_pair" "network_primary" {
  provider = aws.networking_prd

  key_name = "me"
}

data "aws_key_pair" "network_failover" {
  provider = aws.networking_prd_failover

  key_name = "me"
}

data "aws_key_pair" "spoke_a_prd_primary" {
  provider = aws.workload_spoke_a_prd

  key_name = "me"
}

data "aws_key_pair" "spoke_a_prd_failover" {
  provider = aws.workload_spoke_a_prd_failover

  key_name = "me"
}

data "aws_key_pair" "spoke_b_prd_primary" {
  provider = aws.workload_spoke_b_prd

  key_name = "me"
}

data "aws_key_pair" "spoke_b_prd_failover" {
  provider = aws.workload_spoke_b_prd_failover

  key_name = "me"
}

#inbound-primary
data "aws_vpc" "inbound_primary" {
  provider = aws.networking_prd

  filter {
    name   = "cidr-block"
    values = [var.vpc_cidr_infrastructure.inbound_primary]
  }
}

data "aws_subnets" "inbound_primary" {
  provider = aws.networking_prd

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.inbound_primary.id]
  }

  tags = { Name = "*-pub-*" }
}

data "aws_security_group" "inbound_primary" {
  provider = aws.networking_prd

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.inbound_primary.id]
  }

  tags = { Name = "*-main-sg" }
}

#inspection-primary
data "aws_vpc" "inspection_primary" {
  provider = aws.networking_prd

  filter {
    name   = "cidr-block"
    values = [var.vpc_cidr_infrastructure.inspection_primary]
  }
}

data "aws_subnets" "inspection_primary" {
  provider = aws.networking_prd

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.inspection_primary.id]
  }

  tags = { Name = "*-firewall-*" }
}

data "aws_security_group" "inspection_primary" {
  provider = aws.networking_prd

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.inspection_primary.id]
  }

  tags = { Name = "*-main-sg" }
}

#inspection-failover
data "aws_vpc" "inspection_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  filter {
    name   = "cidr-block"
    values = [var.vpc_cidr_infrastructure.inspection_failover]
  }
}

data "aws_subnets" "inspection_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.inspection_failover[0].id]
  }

  tags = { Name = "*-firewall-*" }
}

data "aws_security_group" "inspection_failover" {
  provider = aws.networking_prd_failover

  count = var.create_failover_region ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.inspection_failover[0].id]
  }

  tags = { Name = "*-main-sg" }
}

#outbound-primary
data "aws_vpc" "outbound_primary" {
  provider = aws.networking_prd

  filter {
    name   = "cidr-block"
    values = [var.vpc_cidr_infrastructure.outbound_primary]
  }
}

data "aws_subnets" "outbound_primary" {
  provider = aws.networking_prd

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.outbound_primary.id]
  }

  tags = { Name = "*-pub-*" }
}

data "aws_security_group" "outbound_primary" {
  provider = aws.networking_prd

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.outbound_primary.id]
  }

  tags = { Name = "*-main-sg" }
}

#spoke-a-primary
data "aws_vpc" "spoke_a_prd_primary" {
  provider = aws.workload_spoke_a_prd

  filter {
    name   = "cidr-block"
    values = [var.vpc_cidr_infrastructure.workload_spoke_a_prd_primary]
  }
}

data "aws_subnets" "spoke_a_prd_primary" {
  provider = aws.workload_spoke_a_prd

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.spoke_a_prd_primary.id]
  }

  tags = { Name = "*-pvt-*" }
}

data "aws_security_group" "spoke_a_prd_primary" {
  provider = aws.workload_spoke_a_prd

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.spoke_a_prd_primary.id]
  }

  tags = { Name = "*-main-sg" }
}

#spoke-a-failover
data "aws_vpc" "spoke_a_prd_failover" {
  provider = aws.workload_spoke_a_prd_failover

  count = var.create_failover_region ? 1 : 0

  filter {
    name   = "cidr-block"
    values = [var.vpc_cidr_infrastructure.workload_spoke_a_prd_failover]
  }
}

data "aws_subnets" "spoke_a_prd_failover" {
  provider = aws.workload_spoke_a_prd_failover

  count = var.create_failover_region ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.spoke_a_prd_failover[0].id]
  }

  tags = { Name = "*-pvt-*" }
}

data "aws_security_group" "spoke_a_prd_failover" {
  provider = aws.workload_spoke_a_prd_failover

  count = var.create_failover_region ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.spoke_a_prd_failover[0].id]
  }

  tags = { Name = "*-main-sg" }
}

#spoke-b-primary
data "aws_vpc" "spoke_b_prd_primary" {
  provider = aws.workload_spoke_b_prd

  filter {
    name   = "cidr-block"
    values = [var.vpc_cidr_infrastructure.workload_spoke_b_prd_primary]
  }
}

data "aws_subnets" "spoke_b_prd_primary" {
  provider = aws.workload_spoke_b_prd

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.spoke_b_prd_primary.id]
  }

  tags = { Name = "*-pvt-*" }
}

data "aws_security_group" "spoke_b_prd_primary" {
  provider = aws.workload_spoke_b_prd

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.spoke_b_prd_primary.id]
  }

  tags = { Name = "*-main-sg" }
}