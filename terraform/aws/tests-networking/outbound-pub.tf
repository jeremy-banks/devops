data "aws_vpc" "outbound_primary" {
  provider = aws.networking_prd

  filter {
    name   = "cidr-block"
    values = [var.vpc_cidr_infrastructure.outbound_primary]
  }
}

data "aws_subnets" "outbound_pub_primary" {
  provider = aws.networking_prd

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.outbound_primary.id]
  }

  tags = { Name = "*-pub-*" }
}

data "aws_subnets" "outbound_tgw_primary" {
  provider = aws.networking_prd

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.outbound_primary.id]
  }

  tags = { Name = "*-tgw-*" }
}

data "aws_security_group" "outbound_primary" {
  provider = aws.networking_prd

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.outbound_primary.id]
  }

  tags = { Name = "*-main-sg" }
}

# output "test" {
#   value = data.aws_subnets.spoke_a_pub_primary.ids
# }

# data "template_file" "outbound_pub_userdata_primary" {
#   template = <<-EOF

#   EOF
# }

module "outbound_pub_primary" {
  source    = "terraform-aws-modules/ec2-instance/aws"
  version   = "5.8.0"
  providers = { aws = aws.networking_prd }

  #   count = var.azs_used

  name = "${var.this_slug}-outbound-pub"

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t4g.nano"

  subnet_id              = element(data.aws_subnets.outbound_pub_primary.ids, 0)
  vpc_security_group_ids = [data.aws_security_group.outbound_primary.id]

  associate_public_ip_address = true
  key_name                    = "me"

  create_iam_instance_profile = true
  iam_role_policies           = { PowerUserAccess = "arn:aws:iam::aws:policy/PowerUserAccess" }

  user_data = templatefile("user_data.tftpl", {
    instance_name   = "${var.this_slug}-outbound-pub",
    instance_region = var.region.primary,
  })
}

module "outbound_pvt_primary" {
  source    = "terraform-aws-modules/ec2-instance/aws"
  version   = "5.8.0"
  providers = { aws = aws.networking_prd }

  #   count = var.azs_used

  name = "${var.this_slug}-outbound-pvt"

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t4g.nano"

  subnet_id              = element(data.aws_subnets.outbound_tgw_primary.ids, 0)
  vpc_security_group_ids = [data.aws_security_group.outbound_primary.id]

  # associate_public_ip_address = true
  key_name = "me"

  create_iam_instance_profile = true
  iam_role_policies           = { PowerUserAccess = "arn:aws:iam::aws:policy/PowerUserAccess" }

  user_data = templatefile("user_data.tftpl", {
    instance_name   = "${var.this_slug}-outbound-pvt",
    instance_region = var.region.primary,
  })
}