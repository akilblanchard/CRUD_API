

#Lambda Data File
data "archive_file" "lambda_archive" {
  source_file = "index.js"
  output_path = "lambdas/index.zip"
  type        = "zip"
}

resource "aws_lambda_function" "crud_lambda" {
  function_name = "crud-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  filename      = "lambdas/index.zip" # Replace with the path to your Lambda deployment package (ZIP file)

  source_code_hash = data.archive_file.lambda_archive.output_base64sha256
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_execution_policy"
  description = "IAM policy for Lambda execution role"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "dynamodb:DeleteItem",
        Effect   = "Allow",
        Resource = "arn:aws:dynamodb:us-west-1:123456789012:table/http-crud-tutorial-items"
      },
      {
        Action   = "dynamodb:GetItem",
        Effect   = "Allow",
        Resource = "arn:aws:dynamodb:us-west-1:123456789012:table/http-crud-tutorial-items"
      },
      {
        Action   = "dynamodb:PutItem",
        Effect   = "Allow",
        Resource = "arn:aws:dynamodb:us-west-1:123456789012:table/http-crud-tutorial-items"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_role.name
  }
