resource "aws_iam_policy" "permission_boundary" {
  name        = "${local.resource_name_stub}-permission-boundary"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # allow global actions
      {
        Sid       = "AllowGlobalActions",
        Effect    = "Allow",
        Action    = [
          "cloudfront:*",
          "iam:*",
          "route53:*",
          "support:*",
        ],
        Resource  = "*",
      },

      {
        # allow regional actions in permitted regions
        Sid       = "AllowNonGlobalActionsInPermittedRegions",
        Effect    = "Allow",
        NotAction = [
          "cloudfront:*",
          "iam:*",
          "route53:*",
          "support:*",
        ],
        Resource  = "*",
        Condition = {
          StringEquals = {
            "aws:RequestedRegion" = [
              "${var.region_primary}",
              "${var.region_secondary}"
            ]
          }
        }
      },

      {
        # allow actions on tagged infra
        Sid       = "AllowActionsOnTaggedInfra",
        Effect    = "Allow",
        Action    = "*",
        Resource  = "*",
        Condition = {
          StringEquals  = {
            "aws:RequestTag/${local.iam_access_management_tag_key}" = local.iam_access_management_tag_value
          }
        }
      }

    ]
  })
}