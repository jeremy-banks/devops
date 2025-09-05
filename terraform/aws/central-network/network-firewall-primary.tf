module "network_firewall_primary" {
  source    = "terraform-aws-modules/network-firewall/aws"
  version   = "~> 2.0.1"
  providers = { aws = aws.network_prd }

  # Firewall
  name        = "${local.resource_name_primary}-firewall"
  description = "Example network firewall"

  # Only for example
  delete_protection                 = false
  firewall_policy_change_protection = false
  subnet_change_protection          = false

  vpc_id = module.vpc_inspection_primary.vpc_id
  subnet_mapping = { for i in range(0, length(module.vpc_inspection_primary.private_subnets)) :
    "subnet-${i}" => {
      subnet_id       = element(module.vpc_inspection_primary.private_subnets, i)
      ip_address_type = "IPV4"
    }
  }

  # Logging configuration
  create_logging_configuration = true
  logging_configuration_destination_config = [
    {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.logs_primary.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    },
    {
      log_destination = {
        bucketName = aws_s3_bucket.network_firewall_logs_primary.id
        prefix     = "${local.resource_name_primary}-${var.this_slug}"
      }
      log_destination_type = "S3"
      log_type             = "FLOW"
    }
  ]

  # Policy
  policy_name        = "${local.resource_name_primary}-${var.this_slug}-policy"
  policy_description = "Example network firewall policy"

  # policy_stateful_rule_group_reference = {
  #   one = { resource_arn = module.network_firewall_rule_group_stateful.arn }
  # }

  policy_stateless_default_actions          = ["aws:pass"]
  policy_stateless_fragment_default_actions = ["aws:pass"]
  # policy_stateless_rule_group_reference = {
  #   one = {
  #     priority     = 1
  #     resource_arn = module.network_firewall_rule_group_stateless.arn
  #   }
  # }

  #   tags = local.tags
}