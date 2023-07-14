resource "aws_apigatewayv2_api" "beta-apigw" {
  name          = "beta-apigw"
  protocol_type = "HTTP"
  tags = {
    service = "beta"
  }
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.beta-apigw.id
  name        = "$default"
  auto_deploy = true
}

output "beta-apigw" {
  value = aws_apigatewayv2_api.beta-apigw
}
