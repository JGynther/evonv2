locals {
  env = { for tuple in regexall("(.*)=(.*)", file("services/mordor/auth/.env")) : tuple[0] => tuple[1] }
}

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
  source  = "../../../lib/modules/lambda-apigw"
  name    = "registerClient"
  path    = "services/mordor/auth"
  iam     = aws_iam_role.empty-lambda-role
  service = "mordor-auth"
  apigw   = aws_apigatewayv2_api.mordor-auth-apigw
  route   = "GET /auth/register"
}

module "authorizeDevice" {
  source  = "../../../lib/modules/lambda-apigw"
  name    = "authorizeDevice"
  path    = "services/mordor/auth"
  iam     = aws_iam_role.empty-lambda-role
  service = "mordor-auth"
  apigw   = aws_apigatewayv2_api.mordor-auth-apigw
  route   = "POST /auth/device"
  env = {
    SSOURL = local.env["SSOURL"]
  }
}

module "createToken" {
  source  = "../../../lib/modules/lambda-apigw"
  name    = "createToken"
  path    = "services/mordor/auth"
  iam     = aws_iam_role.empty-lambda-role
  service = "mordor-auth"
  apigw   = aws_apigatewayv2_api.mordor-auth-apigw
  route   = "POST /auth/token"
}

module "getRoleCredentials" {
  source  = "../../../lib/modules/lambda-apigw"
  name    = "getRoleCredentials"
  path    = "services/mordor/auth"
  iam     = aws_iam_role.empty-lambda-role
  service = "mordor-auth"
  apigw   = aws_apigatewayv2_api.mordor-auth-apigw
  route   = "POST /auth/credentials"
  env = {
    ROLE      = local.env["ROLE"]
    ACCOUNTID = local.env["ACCOUNTID"]
  }
}
