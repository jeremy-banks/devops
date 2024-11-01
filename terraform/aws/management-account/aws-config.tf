# # https://github.com/awslabs/aws-config-rules/tree/master/aws-config-conformance-packs
# resource "aws_config_configuration_aggregator" "org_aws_config" {
#   depends_on = [module.iam_role_org_aws_config]

#   name = "${local.resource_name_stub}-aws-config-aggregator"

#   account_aggregation_source {
#     account_ids = ["418295702066"]
#     regions = [var.region.primary]
#   }

# # enable this when you're funded
# #   organization_aggregation_source {
# #     all_regions = true
# #     role_arn    = aws_iam_role.org_aws_config.arn
# #   }
# }

# data "aws_iam_policy_document" "org_aws_config_assume_role_policy" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["config.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# module "iam_role_org_aws_config" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
#   version = "5.47.1"

#   role_name  = "${local.resource_name_stub}-aws-config-role"

#   create_role = true
#   role_requires_mfa = false

#   trusted_role_services = ["config.amazonaws.com"]
#   custom_role_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSConfigRoleForOrganizations"]
#   inline_policy_statements = [
#     {
#       actions = ["s3:*"]
#       effect    = "Allow"
#       resources = [
#         module.s3_org_aws_config.s3_bucket_arn,
#         "${module.s3_org_aws_config.s3_bucket_arn}/*"
#       ]
#     }
#   ]
# }

# resource "aws_config_delivery_channel" "org_aws_config" {
#   name           = "${local.resource_name_stub_primary}-aws-config-delivery-channel"
#   s3_bucket_name = module.s3_org_aws_config.s3_bucket_id
#   depends_on     = [aws_config_configuration_recorder.org_aws_config]
# }

# module "s3_org_aws_config" {
#   source  = "terraform-aws-modules/s3-bucket/aws"
#   version = "4.2.1"
#   providers = { aws = aws.org }

#   bucket = "${local.resource_name_stub_primary}-aws-config-storage-blob-${local.unique_id}"

#   force_destroy = true

#   server_side_encryption_configuration = {
#     rule = {
#       apply_server_side_encryption_by_default = {
#         # kms_master_key_id = module.kms_primary.key_arn
#         sse_algorithm     = "AES256"
#       }
#       bucket_key_enabled = true
#     }
#   }

#   lifecycle_rule = [
#     {
#       id      = "intelligent-tier"
#       enabled = true
#       abort_incomplete_multipart_upload_days = 7

#       transition = [ { storage_class = "INTELLIGENT_TIERING" } ]
#       noncurrent_version_transition = [ { storage_class = "INTELLIGENT_TIERING" } ]
#     }
#   ]

#   versioning = { enabled = true }

#   # attach_deny_incorrect_encryption_headers  = true
#   # attach_deny_incorrect_kms_key_sse         = true
#   # allowed_kms_key_arn                       = module.kms_primary.key_arn
# }

# resource "aws_config_configuration_recorder" "org_aws_config" {
#   name     = "${local.resource_name_stub}-aws-config-recorder"
#   role_arn = module.iam_role_org_aws_config.iam_role_arn

#   recording_group {
#     all_supported                 = true
#     include_global_resource_types = true
#     # resource_types                = ["AWS::EC2::Instance", "AWS::EC2::NetworkInterface"]
#   }

#   recording_mode {
#     recording_frequency = "DAILY"
#   }
# }

# resource "aws_config_configuration_recorder_status" "org_aws_config" {
#   name       = aws_config_configuration_recorder.org_aws_config.name
#   is_enabled = true
#   depends_on = [aws_config_delivery_channel.org_aws_config]
# }

# # resource "aws_config_organization_conformance_pack" "example" {
# #   name = "example"

# #   input_parameter {
# #     parameter_name  = "AccessKeysRotatedParameterMaxAccessKeyAge"
# #     parameter_value = "90"
# #   }

# #   template_body = <<EOT
# # Parameters:
# #   AccessKeysRotatedParameterMaxAccessKeyAge:
# #     Type: String
# # Resources:
# #   IAMPasswordPolicy:
# #     Properties:
# #       ConfigRuleName: IAMPasswordPolicy
# #       Source:
# #         Owner: AWS
# #         SourceIdentifier: IAM_PASSWORD_POLICY
# #     Type: AWS::Config::ConfigRule
# # EOT

# #   depends_on = [aws_config_configuration_recorder.org_aws_config, aws_organizations_organization.this]
# # }
