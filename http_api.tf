resource "aws_apigatewayv2_api" "crud_api" {
  name          = "crud-example-http-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "crud_api" {
    api_id = aws_apigatewayv2_api.crud_api.id
  name   = "lambda_stage"
  description = "Default Stage"
  auto_deploy = true
}


resource "aws_apigatewayv2_route" "crud_api_route1" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "GET /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.crud_integration.id}"
}

resource "aws_apigatewayv2_route" "crud_api_route2" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "GET /items"
  target    = "integrations/${aws_apigatewayv2_integration.crud_integration.id}"
}

resource "aws_apigatewayv2_route" "crud_api_route3" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "PUT /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.crud_integration.id}"
}

resource "aws_apigatewayv2_integration" "crud_integration" {
  api_id           = aws_apigatewayv2_api.crud_api.id
  integration_type = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.http_crud_func.invoke_arn
}


resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.http_crud_func.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.crud_api.execution_arn}/*/*"
}