module "sg_main_primary" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.3.0"
  providers = { aws = aws.this }

  name        = "${local.resource_name.primary}-main-sg"
  description = "${local.resource_name.primary}-main-sg"
  vpc_id      = module.vpc_primary.vpc_id

  ingress_with_self = [{ rule = "all-all" }]
  egress_with_self  = [{ rule = "all-all" }]

  egress_cidr_blocks      = ["0.0.0.0/0"]
  egress_ipv6_cidr_blocks = ["::/0"]
  egress_rules            = ["all-all"]

  tags = { Name = "${local.resource_name.primary}-main-sg" }
}