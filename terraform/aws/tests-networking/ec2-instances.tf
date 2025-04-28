# inboundA -> tgwA -> inspectionA -> tgwA -> spoke1A
# spoke1A -> tgwA -> inspectionA -> tgwA -> outboundA
# spoke1A <-> tgwA <-> inspectionA <-> tgwA <-> spoke2A
# spoke1A <-> tgwA <-> inspectionA <-> tgwA <-> tgwB <-> inspectionB <-> spoke1B

# this_instance_ping_targets = module.spoke_to_internet_inspection_primary.private_dns,

# #inbound-primary
# module "inbound_primary" {
#   source    = "terraform-aws-modules/ec2-instance/aws"
#   version   = "5.8.0"
#   providers = { aws = aws.networking_prd }

#   #   count = var.azs_used

#   name = "${var.this_slug}-inbound-primary"

#   ami           = data.aws_ami.amazon_linux.id
#   instance_type = "t4g.nano"

#   subnet_id              = element(data.aws_subnets.inbound_primary.ids, 0)
#   vpc_security_group_ids = [data.aws_security_group.inbound_primary.id]

#   associate_public_ip_address = true
#   key_name                    = "me"

#   create_iam_instance_profile = true
#   iam_role_policies           = { PowerUserAccess = "arn:aws:iam::aws:policy/PowerUserAccess" }

#   user_data = templatefile("user_data.tftpl", {
#     cloudwatch_logs_region     = var.region.primary,
#     this_instance_name         = "${var.this_slug}-inbound-primary",
#     this_instance_ping_targets = "google.com",
#     this_instance_region       = var.region.primary,
#   })
# }

# #inspection-primary
# module "inspection_primary" {
#   source    = "terraform-aws-modules/ec2-instance/aws"
#   version   = "5.8.0"
#   providers = { aws = aws.networking_prd }

#   #   count = var.azs_used

#   name = "${var.this_slug}-inspection-primary"

#   ami           = data.aws_ami.amazon_linux.id
#   instance_type = "t4g.nano"

#   subnet_id              = element(data.aws_subnets.inspection_primary.ids, 0)
#   vpc_security_group_ids = [data.aws_security_group.inspection_primary.id]

#   associate_public_ip_address = true
#   key_name                    = "me"

#   create_iam_instance_profile = true
#   iam_role_policies           = { PowerUserAccess = "arn:aws:iam::aws:policy/PowerUserAccess" }

#   user_data = templatefile("user_data.tftpl", {
#     cloudwatch_logs_region     = var.region.primary,
#     this_instance_name         = "${var.this_slug}-inspection-primary",
#     this_instance_region       = var.region.primary,
#     this_instance_ping_targets = "google.com",
#   })
# }

# #inspection-failover
# module "inspection_failover" {
#   source    = "terraform-aws-modules/ec2-instance/aws"
#   version   = "5.8.0"
#   providers = { aws = aws.networking_prd_failover }

#   #   count = var.azs_used

#   name = "${var.this_slug}-inspection-failover"

#   ami           = data.aws_ami.amazon_linux.id
#   instance_type = "t4g.nano"

#   subnet_id              = element(data.aws_subnets.inspection_failover.ids, 0)
#   vpc_security_group_ids = [data.aws_security_group.inspection_failover.id]

#   associate_public_ip_address = true
#   key_name                    = "me"

#   create_iam_instance_profile = true
#   iam_role_policies           = { PowerUserAccess = "arn:aws:iam::aws:policy/PowerUserAccess" }

#   user_data = templatefile("user_data.tftpl", {
#     cloudwatch_logs_region     = var.region.primary,
#     this_instance_name         = "${var.this_slug}-inspection-failover",
#     this_instance_region       = var.region.failover,
#     this_instance_ping_targets = "google.com",
#   })
# }

#outbound-primary
module "outbound_primary" {
  source    = "terraform-aws-modules/ec2-instance/aws"
  version   = "5.8.0"
  providers = { aws = aws.networking_prd }

  #   count = var.azs_used

  name = "${var.this_slug}-outbound-primary"

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t4g.nano"

  subnet_id              = element(data.aws_subnets.outbound_primary.ids, 0)
  vpc_security_group_ids = [data.aws_security_group.outbound_primary.id]

  associate_public_ip_address = true
  key_name                    = "me"

  create_iam_instance_profile = true
  iam_role_policies           = { PowerUserAccess = "arn:aws:iam::aws:policy/PowerUserAccess" }

  user_data = templatefile("user_data.tftpl", {
    cloudwatch_logs_region = var.region.primary,
    this_instance_name     = "${var.this_slug}-outbound-primary",
    this_instance_region   = var.region.primary,
    this_instance_ping_targets = join(" ", [
      "google.com",
      "bing.com",
    ])
  })
}

# #spoke-a-primary
# module "spoke_a_primary" {
#   source    = "terraform-aws-modules/ec2-instance/aws"
#   version   = "5.8.0"
#   providers = { aws = aws.workload_spoke_a_prd }

#   #   count = var.azs_used

#   name = "${var.this_slug}-spoke-a-primary"

#   ami           = data.aws_ami.amazon_linux.id
#   instance_type = "t4g.nano"

#   subnet_id              = element(data.aws_subnets.spoke_a_primary.ids, 0)
#   vpc_security_group_ids = [data.aws_security_group.spoke_a_primary.id]

#   associate_public_ip_address = true
#   key_name                    = "me"

#   create_iam_instance_profile = true
#   iam_role_policies           = { PowerUserAccess = "arn:aws:iam::aws:policy/PowerUserAccess" }

#   user_data = templatefile("user_data.tftpl", {
#     cloudwatch_logs_region     = var.region.primary,
#     this_instance_name         = "${var.this_slug}-spoke-a-primary",
#     this_instance_region       = var.region.primary,
#     this_instance_ping_targets = "google.com",
#   })
# }

# #spoke-a-failover
# module "spoke_a_failover" {
#   source    = "terraform-aws-modules/ec2-instance/aws"
#   version   = "5.8.0"
#   providers = { aws = aws.workload_spoke_a_prd_failover }

#   #   count = var.azs_used

#   name = "${var.this_slug}-spoke-a-failover"

#   ami           = data.aws_ami.amazon_linux.id
#   instance_type = "t4g.nano"

#   subnet_id              = element(data.aws_subnets.spoke_a_failover.ids, 0)
#   vpc_security_group_ids = [data.aws_security_group.spoke_a_failover.id]

#   associate_public_ip_address = true
#   key_name                    = "me"

#   create_iam_instance_profile = true
#   iam_role_policies           = { PowerUserAccess = "arn:aws:iam::aws:policy/PowerUserAccess" }

#   user_data = templatefile("user_data.tftpl", {
#     cloudwatch_logs_region     = var.region.primary,
#     this_instance_name         = "${var.this_slug}-spoke-a-failover",
#     this_instance_region       = var.region.failover,
#     this_instance_ping_targets = "google.com",
#   })
# }

# #spoke-b-primary
# module "spoke_b_primary" {
#   source    = "terraform-aws-modules/ec2-instance/aws"
#   version   = "5.8.0"
#   providers = { aws = aws.workload_spoke_b_prd }

#   #   count = var.azs_used

#   name = "${var.this_slug}-spoke-b-primary"

#   ami           = data.aws_ami.amazon_linux.id
#   instance_type = "t4g.nano"

#   subnet_id              = element(data.aws_subnets.spoke_b_primary.ids, 0)
#   vpc_security_group_ids = [data.aws_security_group.spoke_b_primary.id]

#   associate_public_ip_address = true
#   key_name                    = "me"

#   create_iam_instance_profile = true
#   iam_role_policies           = { PowerUserAccess = "arn:aws:iam::aws:policy/PowerUserAccess" }

#   user_data = templatefile("user_data.tftpl", {
#     cloudwatch_logs_region     = var.region.primary,
#     this_instance_name         = "${var.this_slug}-spoke-b-primary",
#     this_instance_region       = var.region.primary,
#     this_instance_ping_targets = "google.com",
#   })
# }