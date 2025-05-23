module "sg_inbound_main_failover" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.3.0"
  providers = { aws = aws.networking_prd_failover }

  count = var.create_failover_region ? 1 : 0

  name        = "${local.resource_name_stub_failover}-${var.this_slug}-inbound-main-sg"
  description = "${local.resource_name_stub_failover}-${var.this_slug}-inbound-main-sg"
  vpc_id      = module.vpc_inbound_failover[0].vpc_id

  ingress_with_self = [{ rule = "all-all" }]
  egress_with_self  = [{ rule = "all-all" }]

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = { Name = "${local.resource_name_stub_failover}-${var.this_slug}-inbound-main-sg" }
}

module "sg_inspection_main_failover" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.3.0"
  providers = { aws = aws.networking_prd_failover }


  count       = var.create_failover_region ? 1 : 0
  name        = "${local.resource_name_stub_failover}-${var.this_slug}-inspection-main-sg"
  description = "${local.resource_name_stub_failover}-${var.this_slug}-inspection-main-sg"
  vpc_id      = module.vpc_inspection_failover[0].vpc_id

  ingress_with_self = [{ rule = "all-all" }]
  egress_with_self  = [{ rule = "all-all" }]

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = { Name = "${local.resource_name_stub_failover}-${var.this_slug}-inspection-main-sg" }
}

module "sg_outbound_main_failover" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.3.0"
  providers = { aws = aws.networking_prd_failover }

  count = var.create_failover_region ? 1 : 0

  name        = "${local.resource_name_stub_failover}-${var.this_slug}-outbound-main-sg"
  description = "${local.resource_name_stub_failover}-${var.this_slug}-outbound-main-sg"
  vpc_id      = module.vpc_outbound_failover[0].vpc_id

  ingress_with_self = [{ rule = "all-all" }]
  egress_with_self  = [{ rule = "all-all" }]

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = { Name = "${local.resource_name_stub_failover}-${var.this_slug}-outbound-main-sg" }
}