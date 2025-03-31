# # roles
# module "iam_assumable_roles_identity" {
#   source = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
#   version = "5.54.0"
#   providers = { aws = aws.identity }

#   trusted_role_arns = [
#      "arn:aws:iam::${var.account_id.identity}:root",
#      "arn:aws:iam::${var.account_id.org}:user/${var.assumable_role_name.superadmin}",
#   ]

#   create_admin_role = true
#   admin_role_name   = var.admin_role_name

#   create_poweruser_role = false
#   # poweruser_role_name   = var.assumable_roles_name.poweruser

#   create_readonly_role        = true
#   # readonly_role_name          = var.assumable_roles_name.readonly
#   readonly_role_requires_mfa  = false

#   max_session_duration = 43200
# }

# module "iam_assumable_roles_log_archive" {
#   source = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
#   version = "5.54.0"
#   providers = { aws = aws.log_archive }

#   trusted_role_arns = [
#      "arn:aws:iam::${var.account_id.identity}:root",
#      "arn:aws:iam::${var.account_id.org}:user/${var.assumable_role_name.superadmin}",
#   ]

#   create_admin_role = true
#   admin_role_name   = var.assumable_roles_name.admin

#   create_poweruser_role = true
#   poweruser_role_name   = var.assumable_roles_name.poweruser

#   create_readonly_role        = true
#   readonly_role_name          = var.assumable_roles_name.readonly
#   readonly_role_requires_mfa  = false

#   max_session_duration = 43200
# }

# module "iam_assumable_roles_security_tooling" {
#   source = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
#   version = "5.54.0"
#   providers = { aws = aws.security_tooling }

#   trusted_role_arns = [
#      "arn:aws:iam::${var.account_id.identity}:root",
#      "arn:aws:iam::${var.account_id.org}:user/${var.assumable_role_name.superadmin}",
#   ]

#   create_admin_role = true
#   admin_role_name   = var.assumable_roles_name.admin

#   create_poweruser_role = true
#   poweruser_role_name   = var.assumable_roles_name.poweruser

#   create_readonly_role        = true
#   readonly_role_name          = var.assumable_roles_name.readonly
#   readonly_role_requires_mfa  = false
  
#   max_session_duration = 43200
# }
