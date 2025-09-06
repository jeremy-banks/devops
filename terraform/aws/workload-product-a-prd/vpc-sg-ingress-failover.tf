module "sg_ingress_failover" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.3.0"
  providers = { aws = aws.this_failover }

  count = var.create_failover_region ? 1 : 0

  name        = "${local.resource_name.failover}-ingress-sg"
  description = "${local.resource_name.failover}-ingress-sg"
  vpc_id      = module.vpc_failover[0].vpc_id

  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_ipv6_cidr_blocks = ["::/0"]
  ingress_rules            = ["all-all"]

  tags = { Name = "${local.resource_name.failover}-ingress-sg" }
}