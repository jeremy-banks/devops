resource "null_resource" "set_default_credit_specification" {
  provisioner "local-exec" {
    command = "aws ec2 modify-default-credit-specification --region us-west-1 --instance-family T2 --cpu-credits standard"
    
    environment = {
      AWS_PROFILE = terraform.workspace
    }
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}