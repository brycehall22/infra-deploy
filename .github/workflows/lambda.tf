# Bryce Hall
resource "aws_lambda_function" "brycehall_lambda" {
  function_name = "brycehall_lambda"
  role          = aws_iam_role.lambda_exec_role.arn
  runtime       = "python3.12"
  handler       = "test_script.lambda_handler"
  filename      = "${path.module}/lambda_package.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_package.zip")

  timeout = 10
}