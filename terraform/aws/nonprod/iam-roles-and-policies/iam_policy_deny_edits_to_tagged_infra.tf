# if you add an AWS service to the stack this policy will need to be updated to remain effective
resource "aws_iam_policy" "deny_edits_to_tagged_infra" {
  name        = "${local.resource_name_stub}-deny-edits-to-tagged-infra"
  description = "Prevents unauthorized changes to infrastructure provisioned with IaC"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Deny",
        NotAction = [
          "acm-pca:Describe*",
          "acm-pca:Get*",
          "acm-pca:List*",
          "acm:Describe*",
          "acm:Get*",
          "acm:List*",
          "ec2:Describe*",
          "ec2:Get*",
          "ec2:List*",
          "ec2:Search*",
          "ec2messages:Get*",
          "ecr-public:BatchCheckLayerAvailability",
          "ecr-public:Describe*",
          "ecr-public:Get*",
          "ecr-public:List*",
          "ecr:BatchCheck*",
          "ecr:BatchGet*",
          "ecr:Describe*",
          "ecr:Get*",
          "ecr:List*",
          "ecs:Describe*",
          "ecs:List*",
          "eks:Describe*",
          "eks:List*",
          "dynamodb:BatchGet*",
          "dynamodb:Describe*",
          "dynamodb:Get*",
          "dynamodb:List*",
          "dynamodb:PartiQLSelect",
          "dynamodb:Query",
          "dynamodb:Scan",
          "iam:Get*",
          "iam:List*",
          "kms:Describe*",
          "kms:Get*",
          "kms:List*",
          "network-firewall:Describe*",
          "network-firewall:List*",
          "networkmanager:DescribeGlobalNetworks",
          "networkmanager:Get*",
          "networkmanager:List*",
          "organizations:Describe*",
          "organizations:List*",
          "rds:Describe*",
          "rds:Download*",
          "rds:List*",
          "route53:Get*",
          "route53:List*",
          "route53:Test*",
          "route53domains:Check*",
          "route53domains:Get*",
          "route53domains:List*",
          "route53domains:View*",
          "route53resolver:Get*",
          "route53resolver:List*",
          "s3-object-lambda:Get*",
          "s3-object-lambda:List*",
          "s3:DescribeJob",
          "s3:Get*",
          "s3:List*",
          # "ses:BatchGetMetricData",
          # "ses:Describe*",
          # "ses:Get*",
          # "ses:List*",
          # "sns:Check*",
          # "sns:Get*",
          # "sns:List*",
          # "sqs:Get*",
          # "sqs:List*",
          # "sqs:Receive*",
          "sts:GetAccessKeyInfo",
          "sts:GetCallerIdentity",
          "sts:GetSessionToken",
          "vpc-lattice:Get*",
          "vpc-lattice:List*",
          "waf-regional:Get*",
          "waf-regional:List*",
          "waf:Get*",
          "waf:List*",
          "wafv2:CheckCapacity",
          "wafv2:Describe*",
          "wafv2:Get*",
          "wafv2:List*",
        ],
        Resource = "*",
        Condition = {
          StringEquals = {
            "aws:RequestTag/provisioned_by_iac" = "true"
          }
        }
      }
    ]
  })
}
