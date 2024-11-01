data "aws_iam_policy_document" "deny_s3_unencrypted_uploads" {
# https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_s3.html#example-s3-1
  statement {
    sid       = "PreventAmazonS3EnencryptedObjectUploads"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["*"]
    condition {
      test      = "Null"
      variable  = "s3:x-amz-server-side-encryption"
      values    = ["true"]
    }
  }
}

resource "aws_organizations_policy" "deny_s3_unencrypted_uploads" {
  name        = "deny-s3-unencrypted-uploads"
  description = "Prevent Amazon S3 unencrypted object uploads"
  content     = data.aws_iam_policy_document.deny_s3_unencrypted_uploads.json
}