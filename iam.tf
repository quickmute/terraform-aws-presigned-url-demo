## Create IAM Policy and Role for Lambda
data "aws_iam_policy_document" "lambda_iam_policy" {
  version = "2012-10-17"

  ## This is for log stream
  statement {
    sid    = "CwLogging"
    effect = "Allow"
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream"
    ]
    resources = [
      "arn:aws:logs:${local.regionName}:${local.accountId}:log-group:/aws/lambda/${aws_lambda_function.example.function_name}:*",
      "arn:aws:logs:${local.regionName}:${local.accountId}:log-group:/aws/lambda/${aws_lambda_function.example.function_name}"
    ]
  }

  ## This is for log group
  statement {
    sid    = "CwLogGroups"
    effect = "Allow"
    actions = [
      "logs:DescribeLogGroups",
      "logs:CreateLogGroup"
    ]
    resources = [
      "arn:aws:logs:${local.regionName}:${local.accountId}:log-group:/aws/lambda/${aws_lambda_function.example.function_name}"
    ]
  }

  ## This is for s3 bucket
  statement {
    sid    = "s3bucket"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:List*" 
    ]
    resources = [
      "${aws_s3_bucket.example.arn}",
      "${aws_s3_bucket.example.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "lambda_iam_policy" {
  name   = "${var.lambda_name}-iam-policy"
  policy = data.aws_iam_policy_document.lambda_iam_policy.json
}

data "aws_iam_policy_document" "lambda_assume_policy" {
  statement {
    sid     = "baseRoleAssumptionLambdaService"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "${var.lambda_name}-iam"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "iam_for_lambda" {
  ## Attach the permission policy defined above
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_iam_policy.arn
}