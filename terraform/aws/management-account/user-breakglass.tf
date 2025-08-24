module "iam_user_breakglass" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "6.2.0"

  count = 3

  name = "${var.admin_user_names.breakglass}${count.index + 1}"

  create_login_profile    = true
  password_reset_required = false
  create_access_key       = false

  policies = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess",
  }
}