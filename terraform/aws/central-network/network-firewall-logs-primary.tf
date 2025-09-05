
resource "aws_cloudwatch_log_group" "logs_primary" {
  provider = aws.this

  name              = "${local.resource_name_primary}-logs"
  retention_in_days = 7

  #   tags = local.tags
}

resource "aws_s3_bucket" "network_firewall_logs_primary" {
  provider = aws.this

  bucket        = local.resource_name_globally_unique_primary
  force_destroy = true

  #   tags = local.tags
}

# Logging configuration automatically adds this policy if not present
resource "aws_s3_bucket_policy" "network_firewall_logs_primary" {
  provider = aws.this

  bucket = aws_s3_bucket.network_firewall_logs_primary.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:PutObject"
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:logs:${var.region_primary.full}:${data.aws_caller_identity.this.account_id}:*"
          }
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.this.account_id
            "s3:x-amz-acl"      = "bucket-owner-full-control"
          }
        }
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Resource = "${aws_s3_bucket.network_firewall_logs_primary.arn}/${local.resource_name_primary}-${var.this_slug}/AWSLogs/${data.aws_caller_identity.this.account_id}/*"
        Sid      = "AWSLogDeliveryWrite"
      },
      {
        Action = "s3:GetBucketAcl"
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:logs:${var.region_primary.full}:${data.aws_caller_identity.this.account_id}:*"
          }
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.this.account_id
          }
        }
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Resource = aws_s3_bucket.network_firewall_logs_primary.arn
        Sid      = "AWSLogDeliveryAclCheck"
      },
    ]
  })
}