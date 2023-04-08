data "archive_file" "getStockOfferings" {
  source_file = "services/stock-platform//build/getStockOfferings.js"
  output_path = "services/stock-platform//build/getStockOfferings.zip"
  type        = "zip"
}

resource "aws_lambda_function" "getStockOfferings" {
  environment {
    variables = {
      TABLE = aws_dynamodb_table.stock-offerings.name
    }
  }

  function_name    = "getStockOfferings"
  filename         = "services/stock-platform/build/getStockOfferings.zip"
  handler          = "services/stock-platform/getStockOfferings.handler"
  source_code_hash = data.archive_file.getStockOfferings.output_base64sha256
  runtime          = "nodejs18.x"
  architectures    = ["arm64"]
  role             = aws_iam_role.lambda-stock-offerings.arn

  tags = {
    service = "stock-platform"
  }
}
