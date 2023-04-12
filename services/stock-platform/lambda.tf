data "archive_file" "getStockOfferings" {
  source_file = "services/stock-platform/backend/build/getStockOfferings.js"
  output_path = "services/stock-platform/backend/build/getStockOfferings.zip"
  type        = "zip"
}

resource "aws_lambda_function" "getStockOfferings" {
  environment {
    variables = {
      TABLE = aws_dynamodb_table.stock-offerings.name
    }
  }

  function_name    = "getStockOfferings"
  filename         = "services/stock-platform/backend/build/getStockOfferings.zip"
  handler          = "services/stock-platform/backend/getStockOfferings.handler"
  source_code_hash = data.archive_file.getStockOfferings.output_base64sha256
  runtime          = "nodejs18.x"
  architectures    = ["arm64"]
  role             = aws_iam_role.lambda-stock-offerings.arn

  tags = {
    service = "stock-platform"
  }
}

resource "aws_lambda_permission" "getStockOfferings-apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.getStockOfferings.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.stock-platform-apigw.execution_arn}/*/*"
}

data "archive_file" "subscribeToOffering" {
  source_file = "services/stock-platform/backend/build/subscribeToOffering.js"
  output_path = "services/stock-platform/backend/build/subscribeToOffering.zip"
  type        = "zip"
}

resource "aws_lambda_function" "subscribeToOffering" {
  environment {
    variables = {
      CONFIG = aws_dynamodb_table.stock-offerings.name
      TABLE  = aws_dynamodb_table.stock-subscriptions.name
    }
  }

  function_name    = "subscribeToOffering"
  filename         = "services/stock-platform/backend/build/subscribeToOffering.zip"
  handler          = "services/stock-platform/backend/subscribeToOffering.handler"
  source_code_hash = data.archive_file.subscribeToOffering.output_base64sha256
  runtime          = "nodejs18.x"
  architectures    = ["arm64"]
  role             = aws_iam_role.lambda-subscribe.arn

  tags = {
    service = "stock-platform"
  }
}

resource "aws_lambda_permission" "subscribeToOffering-apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.subscribeToOffering.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.stock-platform-apigw.execution_arn}/*/*"
}

data "archive_file" "confirmSubscribeEvent" {
  source_file = "services/stock-platform/backend/build/confirmSubscribeEvent.js"
  output_path = "services/stock-platform/backend/build/confirmSubscribeEvent.zip"
  type        = "zip"
}

resource "aws_lambda_function" "confirmSubscribeEvent" {
  environment {
    variables = {
      TABLE = aws_dynamodb_table.stock-subscriptions.name
    }
  }

  function_name    = "confirmSubscribeEvent"
  filename         = "services/stock-platform/backend/build/confirmSubscribeEvent.zip"
  handler          = "services/stock-platform/backend/confirmSubscribeEvent.handler"
  source_code_hash = data.archive_file.confirmSubscribeEvent.output_base64sha256
  runtime          = "nodejs18.x"
  architectures    = ["arm64"]
  role             = aws_iam_role.lambda-subscribe.arn

  tags = {
    service = "stock-platform"
  }
}

resource "aws_lambda_permission" "confirmSubscribeEvent-apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.confirmSubscribeEvent.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.stock-platform-apigw.execution_arn}/*/*"
}
