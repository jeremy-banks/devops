module "sg_central_egress_main_primary" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.3.0"
  providers = { aws = aws.networking_prd }

  name        = "${local.resource_name_stub_primary}-${var.this_slug}-central-egress-main-sg"
  description = "${local.resource_name_stub_primary}-${var.this_slug}-central-egress-main-sg"
  vpc_id      = module.vpc_central_egress_primary.vpc_id

  ingress_with_self = [{ rule = "all-all" }]
  egress_with_self  = [{ rule = "all-all" }]

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = { Name = "${local.resource_name_stub_primary}-${var.this_slug}-central-egress-main-sg" }
}