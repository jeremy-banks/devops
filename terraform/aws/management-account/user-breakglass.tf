module "iam_user_breakglass" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.59.0"

  count = 3

  name = "${var.admin_user_names.breakglass}${count.index + 1}"

  create_iam_user_login_profile = true
  password_reset_required       = false
  create_iam_access_key         = false
  policy_arns                   = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}