
resource "aws_cloudwatch_log_group" "logs_failover" {
  provider = aws.this_failover

  count = var.create_failover_region_network ? 1 : 0

  name              = "${local.resource_name.failover}-logs"
  retention_in_days = 7

  #   tags = local.tags
}

resource "aws_s3_bucket" "network_firewall_logs_failover" {
  provider = aws.this_failover

  count = var.create_failover_region_network ? 1 : 0

  bucket        = local.resource_name_full_unique.failover
  force_destroy = true

  #   tags = local.tags
}

# Logging configuration automatically adds this policy if not present
resource "aws_s3_bucket_policy" "network_firewall_logs_failover" {
  provider = aws.this_failover

  count = var.create_failover_region_network ? 1 : 0

  bucket = aws_s3_bucket.network_firewall_logs_failover[0].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:PutObject"
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:logs:${var.region_failover.full}:${data.aws_caller_identity.this.account_id}:*"
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
        Resource = "${aws_s3_bucket.network_firewall_logs_failover[0].arn}/${local.resource_name.failover}-${var.this_slug}/AWSLogs/${data.aws_caller_identity.this.account_id}/*"
        Sid      = "AWSLogDeliveryWrite"
      },
      {
        Action = "s3:GetBucketAcl"
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:logs:${var.region_failover.full}:${data.aws_caller_identity.this.account_id}:*"
          }
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.this.account_id
          }
        }
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Resource = aws_s3_bucket.network_firewall_logs_failover[0].arn
        Sid      = "AWSLogDeliveryAclCheck"
      },
    ]
  })
}