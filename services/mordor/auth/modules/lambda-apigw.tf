variable "name" {}
variable "path" {}
variable "filetype" { default = "js" }
variable "handler" { default = "handler" }
variable "runtime" { default = "nodejs18.x" }
variable "iam" {}
variable "service" {}
variable "apigw" {}
variable "route" {}

data "archive_file" "archive" {
  source_file = "${var.path}/build/${var.name}.${var.filetype}"
  output_path = "${var.path}/build/${var.name}.zip"
  type        = "zip"
}

resource "aws_lambda_function" "function" {
  function_name    = var.name
  filename         = "${var.path}/build/${var.name}.zip"
  handler          = "${var.path}/build/${var.name}.${var.handler}"
  source_code_hash = data.archive_file.archive.output_base64sha256
  runtime          = var.runtime
  architectures    = ["arm64"]
  role             = var.iam.arn

  tags = {
    service = var.service
  }
}

resource "aws_lambda_permission" "apigw-permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.apigw.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "integration" {
  api_id                 = var.apigw.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.function.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "route" {
  api_id    = var.apigw.id
  route_key = var.route
  target    = "integrations/${aws_apigatewayv2_integration.integration.id}"
}
