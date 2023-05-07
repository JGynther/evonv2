resource "aws_apigatewayv2_api" "mordor-auth-apigw" {
  name          = "mordor-auth-apigw"
  protocol_type = "HTTP"
  tags = {
    service = "mordor-auth"
  }
}

output "mordor-auth-apigw" {
  value = aws_apigatewayv2_api.mordor-auth-apigw
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.mordor-auth-apigw.id
  name        = "$default"
  auto_deploy = true
}

module "registerClient" {
  source  = "./modules"
  name    = "registerClient"
  path    = "services/mordor/auth"
  iam     = aws_iam_role.empty-lambda-role
  service = "mordor-auth"
  apigw   = aws_apigatewayv2_api.mordor-auth-apigw
  route   = "GET /auth/register"
}

module "authorizeDevice" {
  source  = "./modules"
  name    = "authorizeDevice"
  path    = "services/mordor/auth"
  iam     = aws_iam_role.empty-lambda-role
  service = "mordor-auth"
  apigw   = aws_apigatewayv2_api.mordor-auth-apigw
  route   = "POST /auth/device"
}

module "createToken" {
  source  = "./modules"
  name    = "createToken"
  path    = "services/mordor/auth"
  iam     = aws_iam_role.empty-lambda-role
  service = "mordor-auth"
  apigw   = aws_apigatewayv2_api.mordor-auth-apigw
  route   = "POST /auth/token"
}

