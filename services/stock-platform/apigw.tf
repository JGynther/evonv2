resource "aws_apigatewayv2_api" "stock-platform-apigw" {
  name          = "stock-platform-apigw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.stock-platform-apigw.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "getStockOfferings-integration" {
  api_id                 = aws_apigatewayv2_api.stock-platform-apigw.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.getStockOfferings.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "getStockOfferings-route" {
  api_id    = aws_apigatewayv2_api.stock-platform-apigw.id
  route_key = "GET /api/offerings"
  target    = "integrations/${aws_apigatewayv2_integration.getStockOfferings-integration.id}"
}

resource "aws_apigatewayv2_integration" "subscribeToOffering-integration" {
  api_id                 = aws_apigatewayv2_api.stock-platform-apigw.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.subscribeToOffering.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "subscribeToOffering-route" {
  api_id    = aws_apigatewayv2_api.stock-platform-apigw.id
  route_key = "POST /api/subscribe"
  target    = "integrations/${aws_apigatewayv2_integration.subscribeToOffering-integration.id}"
}

resource "aws_apigatewayv2_integration" "confirmSubscribeEvent-integration" {
  api_id                 = aws_apigatewayv2_api.stock-platform-apigw.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.confirmSubscribeEvent.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "confirmSubscribeEvent-route" {
  api_id    = aws_apigatewayv2_api.stock-platform-apigw.id
  route_key = "POST /api/confirm"
  target    = "integrations/${aws_apigatewayv2_integration.confirmSubscribeEvent-integration.id}"
}
