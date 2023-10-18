#IAM Role for Lambda
resource "aws_iam_role" "crud_role" {
  name = "crud-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

#IAM Policy for Lambda Function
resource "aws_iam_policy" "crud_policy" {
  name = "crud-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = ["*"]
      }, {
      Effect = "Allow"
      Action = [
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:UpdateItem"
      ]
      Resource = ["*"]
    }]
  })
}


#Attach IAM Role
resource "aws_iam_role_policy_attachment" "example" {
  policy_arn = aws_iam_policy.crud_policy.arn
  role       = aws_iam_role.crud_role.name
}


#Lambda Data File
data "archive_file" "lambda_archive" {
  source_file = "index.mjs"
  output_path = "lambdas/index.zip"
  type        = "zip"
}

#Lambda Function
resource "aws_lambda_function" "http_crud_func" {
  function_name = "HttpCrudLambda"
  filename      = "lambdas/index.zip"
 source_code_hash = data.archive_file.lambda_archive.output_base64sha256
  handler = "index.handler"
  role    = aws_iam_role.crud_role.arn
  runtime = "nodejs14.x"
}




