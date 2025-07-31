#inbound-primary
module "central_ingress_primary" {
  source    = "terraform-aws-modules/ec2-instance/aws"
  version   = "5.8.0"
  providers = { aws = aws.networking_prd }

  name = "inbound-primary-${local.test_start}"

  ami           = data.aws_ami.amazon_linux_primary.id
  instance_type = "t4g.nano"

  subnet_id              = data.aws_subnets.central_ingress_primary.ids[0]
  vpc_security_group_ids = [data.aws_security_group.central_ingress_primary.id]

  associate_public_ip_address = true
  key_name                    = "me"

  iam_instance_profile = aws_iam_role.tests_networking_prd.name

  user_data = templatefile("user_data.tftpl", {
    cloudwatch_logs_region = var.region_primary.full
    test_start             = local.test_start
    test_stop              = local.test_stop
    this_instance_name     = "inbound-primary"
    this_instance_region   = var.region_primary.full
    this_instance_ping_targets = join(" ", [
      "127.0.0.1",
      module.central_inspection_primary.private_dns,
      module.spoke_a_prd_primary.private_dns,
      # module.central_egress_primary.private_dns,
      "google.com",
      "bing.com",
    ])
  })
}

#inspection-primary
module "inspection_primary" {
  source    = "terraform-aws-modules/ec2-instance/aws"
  version   = "5.8.0"
  providers = { aws = aws.networking_prd }

  #   count = var.azs_number_used

  name = "inspection-primary-${local.test_start}"

  ami           = data.aws_ami.amazon_linux_primary.id
  instance_type = "t4g.nano"

  subnet_id              = data.aws_subnets.central_inspection_primary.ids[0]
  vpc_security_group_ids = [data.aws_security_group.central_inspection_primary.id]

  #   associate_public_ip_address = true
  key_name = "me"

  iam_instance_profile = aws_iam_role.tests_networking_prd.name

  user_data = templatefile("user_data.tftpl", {
    cloudwatch_logs_region = var.region_primary.full
    test_start             = local.test_start
    test_stop              = local.test_stop
    this_instance_name     = "inspection-primary"
    this_instance_region   = var.region_primary.full
    this_instance_ping_targets = join(" ", [
      "127.0.0.1",
      # module.spoke_a_prd_primary.private_dns,
      # module.central_egress_primary.private_dns,
      "google.com",
      "bing.com",
    ])
  })
}

#outbound-primary
module "central_egress_primary" {
  source    = "terraform-aws-modules/ec2-instance/aws"
  version   = "5.8.0"
  providers = { aws = aws.networking_prd }

  #   count = var.azs_number_used

  name = "outbound-primary-${local.test_start}"

  ami           = data.aws_ami.amazon_linux_primary.id
  instance_type = "t4g.nano"

  subnet_id              = data.aws_subnets.central_egress_primary.ids[0]
  vpc_security_group_ids = [data.aws_security_group.central_egress_primary.id]

  # associate_public_ip_address = true
  key_name = "me"

  iam_instance_profile = aws_iam_role.tests_networking_prd.name

  user_data = templatefile("user_data.tftpl", {
    cloudwatch_logs_region = var.region_primary.full
    test_start             = local.test_start
    test_stop              = local.test_stop
    this_instance_name     = "outbound-primary"
    this_instance_region   = var.region_primary.full
    this_instance_ping_targets = join(" ", [
      "127.0.0.1",
      "google.com",
      "bing.com",
    ])
  })
}

#spoke-a-primary
module "spoke_a_prd_primary" {
  source    = "terraform-aws-modules/ec2-instance/aws"
  version   = "5.8.0"
  providers = { aws = aws.workload_spoke_a_prd }

  #   count = var.azs_number_used

  name = "spoke-a-prd-primary-${local.test_start}"

  ami           = data.aws_ami.amazon_linux_primary.id
  instance_type = "t4g.nano"

  subnet_id              = data.aws_subnets.spoke_a_prd_primary.ids[0]
  vpc_security_group_ids = [data.aws_security_group.spoke_a_prd_primary.id]

  # associate_public_ip_address = true
  key_name = "me"

  iam_instance_profile = aws_iam_role.tests_networking_prd.name

  user_data = templatefile("user_data.tftpl", {
    cloudwatch_logs_region = var.region_primary.full
    test_start             = local.test_start
    test_stop              = local.test_stop
    this_instance_name     = "spoke-a-prd-primary"
    this_instance_region   = var.region_primary.full
    this_instance_ping_targets = join(" ", [
      "127.0.0.1",
      # module.central_inspection_primary.private_dns,
      # module.spoke_a_prd_failover[0].private_dns,
      module.spoke_b_prd_primary.private_dns,
      "google.com",
      "bing.com",
    ])
  })
}

# #spoke-b-primary
module "spoke_b_prd_primary" {
  source    = "terraform-aws-modules/ec2-instance/aws"
  version   = "5.8.0"
  providers = { aws = aws.workload_spoke_b_prd }

  #   count = var.azs_number_used

  name = "spoke-b-prd-primary-${local.test_start}"

  ami           = data.aws_ami.amazon_linux_primary.id
  instance_type = "t4g.nano"

  subnet_id              = data.aws_subnets.spoke_b_prd_primary.ids[0]
  vpc_security_group_ids = [data.aws_security_group.spoke_b_prd_primary.id]

  # associate_public_ip_address = true
  key_name = "me"

  iam_instance_profile = aws_iam_role.tests_networking_prd.name

  user_data = templatefile("user_data.tftpl", {
    cloudwatch_logs_region = var.region_primary.full
    test_start             = local.test_start
    test_stop              = local.test_stop
    this_instance_name     = "spoke-b-prd-primary"
    this_instance_region   = var.region_primary.full
    this_instance_ping_targets = join(" ", [
      "127.0.0.1",
      "google.com",
      "bing.com",
    ])
  })
}