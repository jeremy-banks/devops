# data "aws_vpc" "spoke_a_primary" {
#   provider = aws.workload_spoke_a_prd

#   filter {
#     name   = "cidr-block"
#     values = [var.vpc_cidr_infrastructure.workload_spoke_a_prd_primary]
#   }
# }

# data "aws_subnets" "spoke_a_pub_primary" {
#   provider = aws.workload_spoke_a_prd

#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.spoke_a_primary.id]
#   }

#   tags = { Name = "*-pvt-*" }
# }

# data "aws_security_group" "spoke_a_primary" {
#   provider = aws.workload_spoke_a_prd

#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.spoke_a_primary.id]
#   }

#   tags = { Name = "*-main-sg" }
# }

# # output "test" {
# #   value = data.aws_subnets.spoke_a_pub_primary.ids
# # }

# data "template_file" "spoke_a_pvt_userdata_primary" {
#   template = <<-EOF
#     #!/bin/bash
#     # yum update -y
#     # yum install -y awslogs

#     # cat > /etc/awslogs/awslogs.conf <<CONFIG
#     # [general]
#     # state_file = /var/lib/awslogs/agent-state

#     # [/var/log/cloud-init.log]
#     # file = /var/log/cloud-init.log
#     # log_group_name = /ec2/user-data-output
#     # log_stream_name = ${var.this_slug}-spoke-a-pvt
#     # datetime_format = %Y-%m-%dT%H:%M:%S
#     # CONFIG

#     # sed -i "s/region = .*/region = ${var.region.primary}/" /etc/awslogs/awscli.conf

#     # systemctl enable awslogsd
#     # systemctl start awslogsd

#     sleep 3

#     ping google.com

#     sleep 3

#     shutdown
#   EOF
# }

# module "spoke_a_pvt_primary" {
#   source    = "terraform-aws-modules/ec2-instance/aws"
#   version   = "5.8.0"
#   providers = { aws = aws.workload_spoke_a_prd }

#   #   count = var.azs_used

#   name = "${var.this_slug}-spoke-a-pvt"

#   ami           = data.aws_ami.amazon_linux.id
#   instance_type = "t4g.nano"

#   subnet_id              = element(data.aws_subnets.spoke_a_pub_primary.ids, 0)
#   vpc_security_group_ids = [data.aws_security_group.spoke_a_primary.id]

#   create_iam_instance_profile = true
#   iam_role_policies           = { PowerUserAccess = "arn:aws:iam::aws:policy/PowerUserAccess" }

#   user_data_base64 = base64encode(data.template_file.spoke_a_pvt_userdata_primary.rendered)
# }