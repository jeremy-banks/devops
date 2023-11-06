resource "aws_iam_policy" "allow_self_manage_creds_and_mfa" {
  name        = "${var.name_prefix}-allow-self-manage-creds-and-mfa"
  description = "Allows users to manage their own credentials and MFA"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = [
            "iam:GetAccountPasswordPolicy",
            "iam:ListVirtualMFADevices",
        ],
        Resource  = "*",
      },

      {
        Effect  = "Allow",
        Action  = [
          "iam:*AccessKey*",
          "iam:*LoginProfile*",
          "iam:ChangePassword",
          "iam:CreateServiceSpecificCredential",
          "iam:DeactivateMFADevice",
          "iam:DeleteServiceSpecificCredential",
          "iam:DeleteSigningCertificate",
          "iam:DeleteSSHPublicKey",
          "iam:EnableMFADevice",
          "iam:GetMFADevice",
          "iam:GetSSHPublicKey",
          "iam:GetUser",
          "iam:ListMFADevices",
          "iam:ListServiceSpecificCredentials",
          "iam:ListSigningCertificates",
          "iam:ListSSHPublicKeys",
          "iam:ResetServiceSpecificCredential",
          "iam:ResyncMFADevice",
          "iam:UpdateServiceSpecificCredential",
          "iam:UpdateSigningCertificate",
          "iam:UpdateSSHPublicKey",
          "iam:UploadSigningCertificate",
          "iam:UploadSSHPublicKey",
        ],
        Resource  = "arn:aws:iam::*:user/$${aws:username}",
      },
      
      {
        Effect    = "Allow",
        Action    = "iam:CreateVirtualMFADevice",
        Resource  = "arn:aws:iam::*:mfa/*",
      },

      {
        Effect    = "Deny",
        NotAction = [
          "iam:ChangePassword",
          "iam:CreateVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:GetAccountPasswordPolicy",
          "iam:GetMFADevice",
          "iam:GetUser",
          "iam:ListMFADevices",
          "iam:ListVirtualMFADevices",
          "iam:ResyncMFADevice",
          "sts:GetSessionToken",
        ]
        Resource  = "arn:aws:iam::*:mfa/*",
      },

      {
        Effect= "Allow",
        NotAction= [
            "iam:GetAccountPasswordPolicy",
            "iam:ListVirtualMFADevices",

        ],
        Resource = "*",
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }

    ]
  })
}
