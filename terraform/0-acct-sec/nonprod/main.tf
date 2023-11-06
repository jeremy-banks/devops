# cost - unlimited credits for burstable instance is more expensive, performance workloads should be given production-tier instances such M series or C series
# at the time of writing this terraform doesn't have a resource for these settings so local-exec must be used, and these settings can only be changed once every 5m so a failure will occur if run too often
# however this section is not meant to be changed or executed frequently so it should be fine
# resource "null_resource" "set_default_credit_specification_t2" {
#   provisioner "local-exec" {
#     command = "aws ec2 modify-default-credit-specification --region ${var.region} --instance-family t2 --cpu-credits standard"
    
#     environment = { AWS_PROFILE = var.environment }
#   }

#   triggers = { always_run = "${timestamp()}" }
# }

# resource "null_resource" "set_default_credit_specification_t3" {
#   provisioner "local-exec" {
#     command = "aws ec2 modify-default-credit-specification --region ${var.region} --instance-family t3 --cpu-credits standard"
    
#     environment = { AWS_PROFILE = var.environment }
#   }

#   triggers = { always_run = "${timestamp()}" }
# }

# resource "null_resource" "set_default_credit_specification_t3a" {
#   provisioner "local-exec" {
#     command = "aws ec2 modify-default-credit-specification --region ${var.region} --instance-family t3a --cpu-credits standard"
    
#     environment = { AWS_PROFILE = var.environment }
#   }

#   triggers = { always_run = "${timestamp()}" }
# }

# resource "null_resource" "set_default_credit_specification_t4g" {
#   provisioner "local-exec" {
#     command = "aws ec2 modify-default-credit-specification --region ${var.region} --instance-family t4g --cpu-credits standard"
    
#     environment = { AWS_PROFILE = var.environment }
#   }

#   triggers = { always_run = "${timestamp()}" }
# }

# security - ebs volume encryption enabled by default, will use "alias/aws/ebs"
resource "aws_ebs_encryption_by_default" "aws_ebs_encryption_by_default" {
  enabled = true
}

# security - block all public access to s3 buckets in this account
resource "aws_s3_account_public_access_block" "aws_s3_account_public_access_block" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
