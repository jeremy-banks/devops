resource "aws_iam_policy" "deny_unused_regions" {
  name        = "${local.resource_name_stub}-deny-unused-regions"
  description = "Deny all actions in unused regions"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Deny",
        NotAction = [
            "cloudfront:*",
            "iam:*",
            "route53:*",
            "support:*",
        ],
        Resource = "*",
        Condition = {
          StringNotEquals = {
            "aws:RequestedRegion" = [
                "${var.region_primary}",
                "${var.region_secondary}"
            ]
          }
        }
      }
    ]
  })
}