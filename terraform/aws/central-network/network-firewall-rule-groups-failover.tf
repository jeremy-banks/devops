module "network_firewall_rule_group_stateful_failover" {
  source    = "terraform-aws-modules/network-firewall/aws//modules/rule-group"
  version   = "2.0.1"
  providers = { aws = aws.network_prd_failover }

  count = var.create_failover_region_network ? 1 : 0

  name        = "${local.resource_name_failover}-rule-group-stateful"
  description = "Stateful Inspection for denying access to a domain"
  type        = "STATEFUL"
  capacity    = 100

  rule_group = {
    rules_source = {
      rules_source_list = {
        generated_rules_type = "DENYLIST"
        target_types         = ["HTTP_HOST"]
        targets              = ["test.example.com"]
      }
    }
  }

  # Resource Policy
  create_resource_policy     = true
  attach_resource_policy     = true
  resource_policy_principals = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]

  #   tags = local.tags
}

module "network_firewall_rule_group_stateless_failover" {
  source    = "terraform-aws-modules/network-firewall/aws//modules/rule-group"
  version   = "2.0.1"
  providers = { aws = aws.network_prd_failover }

  count = var.create_failover_region_network ? 1 : 0

  name        = "${local.resource_name_failover}-rule-group-stateless"
  description = "Stateless Inspection with a Custom Action"
  type        = "STATELESS"
  capacity    = 100

  rule_group = {
    rules_source = {
      stateless_rules_and_custom_actions = {
        custom_action = [{
          action_definition = {
            publish_metric_action = {
              dimension = [{
                value = "2"
              }]
            }
          }
          action_name = "ExampleMetricsAction"
        }]
        stateless_rule = [{
          priority = 1
          rule_definition = {
            actions = ["aws:pass", "ExampleMetricsAction"]
            match_attributes = {
              source = [{
                address_definition = "1.2.3.4/32"
              }]
              source_port = [{
                from_port = 443
                to_port   = 443
              }]
              destination = [{
                address_definition = "124.1.1.5/32"
              }]
              destination_port = [{
                from_port = 443
                to_port   = 443
              }]
              protocols = [6]
              tcp_flag = [{
                flags = ["SYN"]
                masks = ["SYN", "ACK"]
              }]
            }
          }
        }]
      }
    }
  }

  # Resource Policy
  create_resource_policy     = true
  attach_resource_policy     = true
  resource_policy_principals = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]

  #   tags = local.tags
}