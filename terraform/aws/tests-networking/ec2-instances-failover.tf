#inbound-failover
module "inbound_failover" {
  source    = "terraform-aws-modules/ec2-instance/aws"
  version   = "5.8.0"
  providers = { aws = aws.networking_prd }

  count = var.create_failover_region ? 1 : 0

  name = "inbound-failover-${local.test_start}"

  ami           = data.aws_ami.amazon_linux_failover.id
  instance_type = "t4g.nano"

  subnet_id              = data.aws_subnets.inbound_failover[0].ids[0]
  vpc_security_group_ids = [data.aws_security_group.inbound_failover[0].id]

  associate_public_ip_address = true
  key_name                    = "me"

  iam_instance_profile = aws_iam_role.tests_networking_prd.name

  user_data = templatefile("user_data.tftpl", {
    cloudwatch_logs_region = var.region.primary
    test_start             = local.test_start
    test_stop              = local.test_stop
    this_instance_name     = "inbound-failover"
    this_instance_region   = var.region.failover
    this_instance_ping_targets = join(" ", [
      "127.0.0.1",
      module.inspection_failover[0].private_dns,
      module.spoke_a_prd_failover[0].private_dns,
      # module.outbound_failover.private_dns,
      "google.com",
      "bing.com",
    ])
  })
}

#inspection-failover
module "inspection_failover" {
  source    = "terraform-aws-modules/ec2-instance/aws"
  version   = "5.8.0"
  providers = { aws = aws.networking_prd }

  count = var.create_failover_region ? 1 : 0

  name = "inspection-failover-${local.test_start}"

  ami           = data.aws_ami.amazon_linux_failover.id
  instance_type = "t4g.nano"

  subnet_id              = data.aws_subnets.inspection_failover[0].ids[0]
  vpc_security_group_ids = [data.aws_security_group.inspection_failover[0].id]

  #   associate_public_ip_address = true
  key_name = "me"

  iam_instance_profile = aws_iam_role.tests_networking_prd.name

  user_data = templatefile("user_data.tftpl", {
    cloudwatch_logs_region = var.region.primary
    test_start             = local.test_start
    test_stop              = local.test_stop
    this_instance_name     = "inspection-failover"
    this_instance_region   = var.region.failover
    this_instance_ping_targets = join(" ", [
      "127.0.0.1",
      # module.spoke_a_prd_failover.private_dns,
      # module.outbound_failover.private_dns,
      "google.com",
      "bing.com",
    ])
  })
}

#outbound-failover
module "outbound_failover" {
  source    = "terraform-aws-modules/ec2-instance/aws"
  version   = "5.8.0"
  providers = { aws = aws.networking_prd }

  count = var.create_failover_region ? 1 : 0

  name = "outbound-failover-${local.test_start}"

  ami           = data.aws_ami.amazon_linux_failover.id
  instance_type = "t4g.nano"

  subnet_id              = data.aws_subnets.outbound_failover[0].ids[0]
  vpc_security_group_ids = [data.aws_security_group.outbound_failover[0].id]

  # associate_public_ip_address = true
  key_name = "me"

  iam_instance_profile = aws_iam_role.tests_networking_prd.name

  user_data = templatefile("user_data.tftpl", {
    cloudwatch_logs_region = var.region.primary
    test_start             = local.test_start
    test_stop              = local.test_stop
    this_instance_name     = "outbound-failover"
    this_instance_region   = var.region.failover
    this_instance_ping_targets = join(" ", [
      "127.0.0.1",
      "google.com",
      "bing.com",
    ])
  })
}

#spoke-a-failover
module "spoke_a_prd_failover" {
  source    = "terraform-aws-modules/ec2-instance/aws"
  version   = "5.8.0"
  providers = { aws = aws.workload_spoke_a_prd }

  count = var.create_failover_region ? 1 : 0

  name = "spoke-a-prd-failover-${local.test_start}"

  ami           = data.aws_ami.amazon_linux_failover.id
  instance_type = "t4g.nano"

  subnet_id              = data.aws_subnets.spoke_a_prd_failover[0].ids[0]
  vpc_security_group_ids = [data.aws_security_group.spoke_a_prd_failover[0].id]

  # associate_public_ip_address = true
  key_name = "me"

  iam_instance_profile = aws_iam_role.tests_networking_prd.name

  user_data = templatefile("user_data.tftpl", {
    cloudwatch_logs_region = var.region.primary
    test_start             = local.test_start
    test_stop              = local.test_stop
    this_instance_name     = "spoke-a-prd-failover"
    this_instance_region   = var.region.failover
    this_instance_ping_targets = join(" ", [
      "127.0.0.1",
      # module.inspection_failover.private_dns,
      # module.spoke_a_prd_failover[0].private_dns,
      module.spoke_b_prd_failover[0].private_dns,
      "google.com",
      "bing.com",
    ])
  })
}

# #spoke-b-failover
module "spoke_b_prd_failover" {
  source    = "terraform-aws-modules/ec2-instance/aws"
  version   = "5.8.0"
  providers = { aws = aws.workload_spoke_b_prd }

  count = var.create_failover_region ? 1 : 0

  name = "spoke-b-prd-failover-${local.test_start}"

  ami           = data.aws_ami.amazon_linux_failover.id
  instance_type = "t4g.nano"

  subnet_id              = data.aws_subnets.spoke_b_prd_failover[0].ids[0]
  vpc_security_group_ids = [data.aws_security_group.spoke_b_prd_failover[0].id]

  # associate_public_ip_address = true
  key_name = "me"

  iam_instance_profile = aws_iam_role.tests_networking_prd.name

  user_data = templatefile("user_data.tftpl", {
    cloudwatch_logs_region = var.region.primary
    test_start             = local.test_start
    test_stop              = local.test_stop
    this_instance_name     = "spoke-b-prd-failover"
    this_instance_region   = var.region.failover
    this_instance_ping_targets = join(" ", [
      "127.0.0.1",
      "google.com",
      "bing.com",
    ])
  })
}