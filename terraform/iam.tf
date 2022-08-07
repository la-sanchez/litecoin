data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "random" {
  statement {
    sid = "1"
    principals {
      identifiers = [data.aws_caller_identity.current.account_id]
      type        = "AWS"
    }
    effect = "Allow"
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "random" {
  name = "random-role"
  assume_role_policy  = data.aws_iam_policy_document.random.json
}

resource "aws_iam_policy" "random" {
  name = "random"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = "sts:AssumeRole",
        Principal = { "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.random.name}" }
    }]
  })
}

resource "aws_iam_group_policy_attachment" "random" {
  group      = aws_iam_group.random.name
  policy_arn = aws_iam_policy.random.arn
}

resource "aws_iam_group" "random" {
  name = "random"
}

resource "aws_iam_user" "random" {
  name = "random"
}

resource "aws_iam_user_group_membership" "random" {
  groups = [aws_iam_group.random.name]
  user   = aws_iam_user.random.name
}