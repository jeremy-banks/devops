module "sg_ingress_primary" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.3.0"
  providers = { aws = aws.this }

  name        = "${local.resource_name_primary}-ingress-sg"
  description = "${local.resource_name_primary}-ingress-sg"
  vpc_id      = module.vpc_primary.vpc_id

  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_ipv6_cidr_blocks = ["::/0"]
  ingress_rules            = ["all-all"]

  tags = { Name = "${local.resource_name_primary}-ingress-sg" }
}