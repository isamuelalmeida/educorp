resource "aws_iam_user" "educorp" {
  name = "educorp"
  path = "/services/"
}

data "aws_iam_policy_document" "educorp_s3_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:*"
    ]

    resources = [
      "arn:aws:s3:::educorp-*",
      "arn:aws:s3:::educorp-*/*"
    ]
  }
}

resource "aws_iam_user_policy" "educorp_s3_policy" {
  name   = "educorp-s3-policy"
  user   = aws_iam_user.educorp.name
  policy = data.aws_iam_policy_document.educorp_s3_policy.json
}

resource "aws_iam_access_key" "educorp_access_key" {
  user = aws_iam_user.educorp.name
}