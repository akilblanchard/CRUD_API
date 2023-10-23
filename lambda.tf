#Lambda to create
resource "aws_lambda_function" "create" {
  function_name = "create"

  role = aws_iam_role.lambda_role.arn


  handler = "create.lambda_handler"
  runtime = "python3.10"

  s3_bucket = "crud-api-bucket"
  s3_key    = "v1.0.0/create.zip"

  
}
#Lambda Create API Permission
resource "aws_lambda_permission" "apigw_create" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.crud_api_gw.execution_arn}/*/POST/items"
}



#Lambda to read
resource "aws_lambda_function" "read" {
  function_name = "read"

  s3_bucket = "crud-api-bucket"
  s3_key    = "v1.0.0/read.zip"

  handler = "read.lambda_handler"
  runtime = "python3.10"

  role = aws_iam_role.lambda_role.arn
}
#Lambda read API permissions
resource "aws_lambda_permission" "apigw_read_item" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.read.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.crud_api_gw.execution_arn}/*/GET/items/{id}"
}
resource "aws_lambda_permission" "apigw_read_all" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.read.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.crud_api_gw.execution_arn}/*/GET/items"
}


#Lambda to update
resource "aws_lambda_function" "update" {
  function_name = "update"

  s3_bucket = "crud-api-bucket"
  s3_key    = "v1.0.0/update.zip"

  handler = "update.lambda_handler"
  runtime = "python3.10"

  role = aws_iam_role.lambda_role.arn
}
#Lambda update Permission
resource "aws_lambda_permission" "apigw_update" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.crud_api_gw.execution_arn}/*/PUT/items/{id}"
}


#Lambda to delete
resource "aws_lambda_function" "delete" {
  function_name = "delete"

  s3_bucket = "crud-api-bucket"
  s3_key    = "v1.0.0/delete.zip"

  handler = "delete.lambda_handler"
  runtime = "python3.10"

  role = aws_iam_role.lambda_role.arn
}
#Lambda delete API Permission
resource "aws_lambda_permission" "apigw_delete" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.crud_api_gw.execution_arn}/*/DELETE/items/{id}"
}


#Lambda Policy
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda-exec-policy"
  description = "IAM policy for Lambda execution role"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "dynamodb:*",
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = "logs:CreateLogGroup",
        Effect = "Allow",
        Resource = "arn:aws:logs:us-east-1:624640980358:*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = [
          "arn:aws:logs:us-east-1:624640980358:log-group:/aws/lambda/*:*"
        ]
      },
      {
        Action = "dynamodb:ListTables",
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}



#Lambda Role
resource "aws_iam_role" "lambda_role" {
  name = "crud-api-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Attach the policy to the Lambda Role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_role.name
}
