data "aws_organizations_organization" "current" {}

#admin
module "iam_group_admin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.32.0"

  name = "admin"
  custom_group_policy_arns = [aws_iam_policy.iam_group_devops_assume_role_policy.arn]
}

resource "aws_iam_policy" "iam_group_admin_assume_role_policy" {
  name        = "AssumeRolePolicyForAdmin"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Resource = ["arn:aws:iam::*:role/admin"],
        Condition = {
          StringEquals = {
            "aws:PrincipalOrgID" = data.aws_organizations_organization.current.id,
          }
        }
      }
    ]
  })
}

#devops
module "iam_group_devops" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.32.0"

  name = "devops"
  custom_group_policy_arns = [aws_iam_policy.iam_group_devops_assume_role_policy.arn]
}

resource "aws_iam_policy" "iam_group_devops_assume_role_policy" {
  name        = "AssumeRolePolicyForDevOps"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Resource = ["arn:aws:iam::*:role/devops"],
        Condition = {
          StringEquals = {
            "aws:PrincipalOrgID" = data.aws_organizations_organization.current.id,
          }
        }
      }
    ]
  })
}

#automation
module "iam_group_automation" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.32.0"

  name = "automation"
  custom_group_policy_arns = [aws_iam_policy.iam_group_automation_assume_role_policy.arn]
}

resource "aws_iam_policy" "iam_group_automation_assume_role_policy" {
  name        = "AssumeRolePolicyForAutomation"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Resource = ["arn:aws:iam::*:role/automation"],
        Condition = {
          StringEquals = {
            "aws:PrincipalOrgID" = data.aws_organizations_organization.current.id,
          }
        }
      }
    ]
  })
}

#dev
module "iam_group_dev" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.32.0"

  name = "dev"
  custom_group_policy_arns = [aws_iam_policy.iam_group_dev_assume_role_policy.arn]
}

resource "aws_iam_policy" "iam_group_dev_assume_role_policy" {
  name        = "AssumeRolePolicyForDev"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Resource = ["arn:aws:iam::*:role/dev"],
        Condition = {
          StringEquals = {
            "aws:PrincipalOrgID" = data.aws_organizations_organization.current.id,
          }
        }
      }
    ]
  })
}

#ops
module "iam_group_ops" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.32.0"

  name = "ops"
  custom_group_policy_arns = [aws_iam_policy.iam_group_ops_assume_role_policy.arn]
}

resource "aws_iam_policy" "iam_group_ops_assume_role_policy" {
  name        = "AssumeRolePolicyForOps"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Resource = ["arn:aws:iam::*:role/ops"],
        Condition = {
          StringEquals = {
            "aws:PrincipalOrgID" = data.aws_organizations_organization.current.id,
          }
        }
      }
    ]
  })
}

#qa
module "iam_group_qa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.32.0"

  name = "qa"
  custom_group_policy_arns = [aws_iam_policy.iam_group_qa_assume_role_policy.arn]
}

resource "aws_iam_policy" "iam_group_qa_assume_role_policy" {
  name        = "AssumeRolePolicyForQA"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Resource = ["arn:aws:iam::*:role/qa"],
        Condition = {
          StringEquals = {
            "aws:PrincipalOrgID" = data.aws_organizations_organization.current.id,
          }
        }
      }
    ]
  })
}

#billing
module "iam_group_billing" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.32.0"

  name = "billing"
  custom_group_policy_arns = [aws_iam_policy.iam_group_billing_assume_role_policy.arn]
}

resource "aws_iam_policy" "iam_group_billing_assume_role_policy" {
  name        = "AssumeRolePolicyForBilling"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Resource = ["arn:aws:iam::*:role/billing"],
        Condition = {
          StringEquals = {
            "aws:PrincipalOrgID" = data.aws_organizations_organization.current.id,
          }
        }
      }
    ]
  })
}
