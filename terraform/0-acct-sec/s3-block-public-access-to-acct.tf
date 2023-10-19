/* data "aws_caller_identity" "current" {}

resource "null_resource" "put_public_access_block" {
  provisioner "local-exec" {
    command = <<EOT
      aws s3control put-public-access-block \
        --account-id ${data.aws_caller_identity.current.account_id} \
        --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
} */