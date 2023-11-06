# admin
resource "aws_iam_group" "admin" {
  name = "admin"
}

resource "aws_iam_group_policy_attachment" "admin_attach" {
  group      = aws_iam_group.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# operations only
resource "aws_iam_group" "operator" {
  name = "operator"
}

# read only
resource "aws_iam_group" "readonly" {
  name = "readonly"
}

resource "aws_iam_group_policy_attachment" "readonly_attach" {
  group      = aws_iam_group.readonly.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
