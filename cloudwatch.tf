resource "aws_cloudwatch_log_group" "crud_lambda_cw" {
  name = "/aws/lambda/${aws_lambda_function.crud_lambda.function_name}"

  retention_in_days = 30
}