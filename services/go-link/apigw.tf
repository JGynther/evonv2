resource "aws_apigatewayv2_api" "go-link-apigw" {
  name          = "go-link-apigw"
  protocol_type = "HTTP"
  tags = {
    service = "go-link"
  }
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.go-link-apigw.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "getLongUrlRedirect-integration" {
  api_id                 = aws_apigatewayv2_api.go-link-apigw.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.getLongUrlRedirect.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "getLongUrlRedirect-route" {
  api_id    = aws_apigatewayv2_api.go-link-apigw.id
  route_key = "GET /{id}"
  target    = "integrations/${aws_apigatewayv2_integration.getLongUrlRedirect-integration.id}"
}
