module "sg_main_failover" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.3.0"
  providers = { aws = aws.workload_spoke_a_prd_failover }

  count = var.create_failover_region ? 1 : 0

  name        = "${local.resource_name_stub_failover}-${var.this_slug}-main-sg"
  description = "${local.resource_name_stub_failover}-${var.this_slug}-main-sg"
  vpc_id      = module.vpc_failover[0].vpc_id

  ingress_with_self = [{ rule = "all-all" }]
  egress_with_self  = [{ rule = "all-all" }]

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = { Name = "${local.resource_name_stub_primary}-${var.this_slug}-main-sg" }
}