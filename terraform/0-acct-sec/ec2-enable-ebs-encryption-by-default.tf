/* resource "null_resource" "enable_ebs_encryption_by_default" {
  provisioner "local-exec" {
    command = "aws ec2 enable-ebs-encryption-by-default"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
} */