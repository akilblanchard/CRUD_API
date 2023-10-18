resource "aws_cloudwatch_log_group" "crud_lambda_cw" {
  name = "/aws/lambda/${aws_lambda_function.http_crud_func.function_name}"

  retention_in_days = 30
}