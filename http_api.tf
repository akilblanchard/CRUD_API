resource "aws_apigatewayv2_api" "crud_api" {
  name          = "crud-example-http-api"
  protocol_type = "HTTP"
}
resource "aws_apigatewayv2_stage" "stage_crud_api" {
  api_id      = aws_apigatewayv2_api.crud_api.id
  name        = "$default"
  auto_deploy = true
}



resource "aws_apigatewayv2_integration" "get_integration" {
  api_id             = aws_apigatewayv2_api.crud_api.id
  integration_method = "GET"
  integration_type   = "HTTP_PROXY"
  integration_uri    = "https://r90xn56w3f.execute-api.us-west-1.amazonaws.com/"
}
resource "aws_apigatewayv2_integration" "get_item_integration" {
  api_id             = aws_apigatewayv2_api.crud_api.id
  integration_method = "GET"
  integration_type   = "HTTP_PROXY"
  integration_uri    = "https://r90xn56w3f.execute-api.us-west-1.amazonaws.com/"
}

resource "aws_apigatewayv2_integration" "put_integration" {
  api_id             = aws_apigatewayv2_api.crud_api.id
  integration_method = "PUT"
 integration_type   = "HTTP_PROXY"
integration_uri    = "https://r90xn56w3f.execute-api.us-west-1.amazonaws.com/" # Update with your PUT endpoint
}

resource "aws_apigatewayv2_integration" "delete_integration" {
 api_id             = aws_apigatewayv2_api.crud_api.id
integration_method = "DELETE"
integration_type   = "HTTP_PROXY"
integration_uri    = "https://r90xn56w3f.execute-api.us-west-1.amazonaws.com/"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.crud_lambda.function_name
  principal     = "apigateway.amazonaws.com"

 source_arn = aws_apigatewayv2_api.crud_api.execution_arn
}


resource "aws_apigatewayv2_route" "crud_api_route_get" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "GET /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.get_integration.id}"
}


resource "aws_apigatewayv2_route" "crud_api_route_get_item" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "GET /items"
  target    = "integrations/${aws_apigatewayv2_integration.get_item_integration.id}"
}

resource "aws_apigatewayv2_route" "crud_api_route_put" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "PUT /items"
  target    = "integrations/${aws_apigatewayv2_integration.put_integration.id}"
}

resource "aws_apigatewayv2_route" "crud_api_route_delete" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "DELETE /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.delete_integration.id}"
}
