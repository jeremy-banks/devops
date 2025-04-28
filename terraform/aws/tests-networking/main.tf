data "aws_caller_identity" "networking" { provider = aws.networking_prd }

data "aws_ami" "amazon_linux" {
  provider = aws.networking_prd

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-arm64-gp2"]
  }
}

data "aws_key_pair" "network_primary" {
  provider = aws.networking_prd

  key_name = "me"
}

data "aws_key_pair" "network_failover" {
  provider = aws.networking_prd_failover

  key_name = "me"
}

data "aws_key_pair" "spoke_a_primary" {
  provider = aws.workload_spoke_a_prd

  key_name = "me"
}

data "aws_key_pair" "spoke_a_failover" {
  provider = aws.workload_spoke_a_prd_failover

  key_name = "me"
}

data "aws_key_pair" "spoke_b_primary" {
  provider = aws.workload_spoke_b_prd

  key_name = "me"
}

data "aws_key_pair" "spoke_b_failover" {
  provider = aws.workload_spoke_b_prd_failover

  key_name = "me"
}