# ZIP the lambda file
data "archive_file" "example" {
  type        = "zip"
  output_path = "${path.module}/lambda/example.zip"
  source_dir  = "${path.module}/lambda/files"
}

# Create a Lambda function
resource "aws_lambda_function" "example" {
  filename      = "${path.module}/lambda/example.zip"
  function_name = var.lambda_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"

  source_code_hash = data.archive_file.example.output_base64sha256

  runtime = "python3.7"

  environment {
    variables = {
      foo = "bar",
      bucket = aws_s3_bucket.example.bucket
    }
  }
}

# This is a resource permission that API GW will normally attach for you if you did this from AWS Console

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${local.regionName}:${local.accountId}:${aws_api_gateway_rest_api.example.id}/*/${aws_api_gateway_method.post.http_method}${aws_api_gateway_resource.example.path}"
}
