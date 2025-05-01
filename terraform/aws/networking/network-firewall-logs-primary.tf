
resource "aws_cloudwatch_log_group" "logs" {
  provider = aws.networking_prd

  name              = "${local.resource_name_stub_primary}-${var.this_slug}-logs"
  retention_in_days = 7

  #   tags = local.tags
}

resource "aws_s3_bucket" "network_firewall_logs" {
  provider = aws.networking_prd

  bucket        = "${local.resource_name_stub_primary}-${var.this_slug}-network-firewall-logs-${data.aws_caller_identity.this.account_id}"
  force_destroy = true

  #   tags = local.tags
}

# Logging configuration automatically adds this policy if not present
resource "aws_s3_bucket_policy" "network_firewall_logs" {
  provider = aws.networking_prd

  bucket = aws_s3_bucket.network_firewall_logs.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:PutObject"
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:logs:${var.region.primary}:${data.aws_caller_identity.this.account_id}:*"
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
        Resource = "${aws_s3_bucket.network_firewall_logs.arn}/${local.resource_name_stub_primary}-${var.this_slug}/AWSLogs/${data.aws_caller_identity.this.account_id}/*"
        Sid      = "AWSLogDeliveryWrite"
      },
      {
        Action = "s3:GetBucketAcl"
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:logs:${var.region.primary}:${data.aws_caller_identity.this.account_id}:*"
          }
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.this.account_id
          }
        }
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Resource = aws_s3_bucket.network_firewall_logs.arn
        Sid      = "AWSLogDeliveryAclCheck"
      },
    ]
  })
}