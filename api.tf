resource "aws_apigatewayv2_api" "crud_api_gw" {
  name          = "crud-http-api"
  protocol_type = "HTTP"
}

#API Stage
resource "aws_apigatewayv2_stage" "stage_crud_api" {
  api_id      = aws_apigatewayv2_api.crud_api_gw.id
  name        = "$default"
  auto_deploy = true
}



#Create Integration
resource "aws_apigatewayv2_integration" "create_integration" {
  api_id                 = aws_apigatewayv2_api.crud_api_gw.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.create.invoke_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}
#Create Route
resource "aws_apigatewayv2_route" "create_route" {
  api_id    = aws_apigatewayv2_api.crud_api_gw.id
  route_key = "POST /items"
  target    = "integrations/${aws_apigatewayv2_integration.create_integration.id}"
}



#Read Integration
resource "aws_apigatewayv2_integration" "read_integration" {
  api_id                 = aws_apigatewayv2_api.crud_api_gw.id
  integration_method     = "POST"
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.read.invoke_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}
#Create Route
resource "aws_apigatewayv2_route" "read_route" {
  api_id    = aws_apigatewayv2_api.crud_api_gw.id
  route_key = "GET /items"
  target    = "integrations/${aws_apigatewayv2_integration.read_integration.id}"
}
#Read Item Route
resource "aws_apigatewayv2_route" "read_item_route" {
  api_id    = aws_apigatewayv2_api.crud_api_gw.id
  route_key = "GET /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.read_integration.id}"
}



#Update Integration
resource "aws_apigatewayv2_integration" "update_integration" {
  api_id                 = aws_apigatewayv2_api.crud_api_gw.id
  integration_method     = "POST"
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.update.invoke_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}
#Update Route
resource "aws_apigatewayv2_route" "update_route" {
  api_id    = aws_apigatewayv2_api.crud_api_gw.id
  route_key = "PUT /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.update_integration.id}"
}



#Delete Integration
resource "aws_apigatewayv2_integration" "delete_integration" {
  api_id                 = aws_apigatewayv2_api.crud_api_gw.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.delete.invoke_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}
#Delete Permissions
resource "aws_apigatewayv2_route" "delete_route" {
  api_id    = aws_apigatewayv2_api.crud_api_gw.id
  route_key = "DELETE /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.delete_integration.id}"
}

