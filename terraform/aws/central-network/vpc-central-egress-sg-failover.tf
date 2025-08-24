module "sg_central_egress_main_failover" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.3.0"
  providers = { aws = aws.network_prd_failover }

  count = var.create_failover_region_network ? 1 : 0

  name        = "${local.resource_name_failover}-central-egress-main-sg"
  description = "${local.resource_name_failover}-central-egress-main-sg"
  vpc_id      = module.vpc_central_egress_failover[0].vpc_id

  ingress_with_self = [{ rule = "all-all" }]
  egress_with_self  = [{ rule = "all-all" }]

  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_ipv6_cidr_blocks = ["::/0"]
  ingress_rules            = ["all-all"]

  egress_cidr_blocks      = ["0.0.0.0/0"]
  egress_ipv6_cidr_blocks = ["::/0"]
  egress_rules            = ["all-all"]

  tags = { Name = "${local.resource_name_failover}-central-egress-main-sg" }
}