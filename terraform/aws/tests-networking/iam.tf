resource "aws_iam_role" "tests_networking_prd" {
  provider = aws.networking_prd

  name = "tests-networking"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "tests_networking_prd" {
  provider = aws.networking_prd

  role       = aws_iam_role.tests_networking_prd.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_instance_profile" "tests_networking_prd" {
  provider = aws.networking_prd

  name = "tests-networking"
  role = aws_iam_role.tests_networking_prd.name
}

resource "aws_iam_role" "tests_workload_spoke_a_prd" {
  provider = aws.workload_spoke_a_prd

  name = "tests-networking"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "tests_workload_spoke_a_prd" {
  provider = aws.workload_spoke_a_prd

  role       = aws_iam_role.tests_workload_spoke_a_prd.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_instance_profile" "tests_workload_spoke_a_prd" {
  provider = aws.workload_spoke_a_prd

  name = "tests-networking"
  role = aws_iam_role.tests_workload_spoke_a_prd.name
}

resource "aws_iam_role" "tests_workload_spoke_b_prd" {
  provider = aws.workload_spoke_b_prd

  name = "tests-networking"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "tests_workload_spoke_b_prd" {
  provider = aws.workload_spoke_b_prd

  role       = aws_iam_role.tests_workload_spoke_b_prd.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_instance_profile" "tests_workload_spoke_b_prd" {
  provider = aws.workload_spoke_b_prd

  name = "tests-networking"
  role = aws_iam_role.tests_workload_spoke_b_prd.name
}
