# role automation
# data "aws_iam_policy_document" "iam_assumable_role_automation_policy" {
#   statement {
#     sid = "AllowS3"
#     effect = "Allow"
#     actions = ["s3:*"]
#     resources = [
#       "arn:aws:s3:::${local.resource_name_stub}-tfstate",
#       "arn:aws:s3:::${local.resource_name_stub}-tfstate/*",
#     ]
#   }
# }

# module "iam_assumable_role_automation_policy" {
#   source = "terraform-aws-modules/iam/aws//modules/iam-policy"
#   version = "5.45.0"
#   providers = { aws = aws.org }

#   name = "automation"

#   policy = data.aws_iam_policy_document.iam_assumable_role_automation_policy.json
# }

# module "iam_assumable_role_automation" {
#   source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
#   version = "5.45.0"
#   providers = { aws = aws.org }

#   trusted_role_arns = [
#      "arn:aws:iam::${var.account_id.identity}:root",
#   ]

#   create_role = true
  
#   role_name = "automation"

#   role_requires_mfa = false
#   max_session_duration = 43200

#   custom_role_policy_arns = [module.iam_assumable_role_automation_policy.arn]
# }

module "iam_assumable_role_automation_identity" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.45.0"
  providers = { aws = aws.identity }

  trusted_role_arns = [
     "arn:aws:iam::${var.account_id.identity}:root",
     "arn:aws:iam::${var.account_id.org}:user/${var.assumable_role_name.automation}",
     "arn:aws:iam::${var.account_id.org}:user/${var.assumable_role_name.superadmin}",
  ]

  create_role = true
  
  role_name = var.assumable_role_name.automation

  attach_admin_policy = true
  role_requires_mfa = false
  max_session_duration = 43200
}

module "iam_assumable_role_automation_log_archive" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.45.0"
  providers = { aws = aws.log_archive }

  trusted_role_arns = [
     "arn:aws:iam::${var.account_id.identity}:root",
     "arn:aws:iam::${var.account_id.org}:user/${var.assumable_role_name.automation}",
     "arn:aws:iam::${var.account_id.org}:user/${var.assumable_role_name.superadmin}",
  ]

  create_role = true
  
  role_name = var.assumable_role_name.automation

  attach_admin_policy = true
  role_requires_mfa = false
  max_session_duration = 43200
}

module "iam_assumable_role_automation_network" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.45.0"
  providers = { aws = aws.network }

  trusted_role_arns = [
     "arn:aws:iam::${var.account_id.identity}:root",
     "arn:aws:iam::${var.account_id.org}:user/${var.assumable_role_name.automation}",
     "arn:aws:iam::${var.account_id.org}:user/${var.assumable_role_name.superadmin}",
  ]

  create_role = true
  
  role_name = var.assumable_role_name.automation

  attach_admin_policy = true
  role_requires_mfa = false
  max_session_duration = 43200
}

module "iam_assumable_role_automation_security_tooling" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.45.0"
  providers = { aws = aws.security_tooling }

  trusted_role_arns = [
     "arn:aws:iam::${var.account_id.identity}:root",
     "arn:aws:iam::${var.account_id.org}:user/${var.assumable_role_name.automation}",
     "arn:aws:iam::${var.account_id.org}:user/${var.assumable_role_name.superadmin}",
  ]

  create_role = true
  
  role_name = var.assumable_role_name.automation

  attach_admin_policy = true
  role_requires_mfa = false
  max_session_duration = 43200
}