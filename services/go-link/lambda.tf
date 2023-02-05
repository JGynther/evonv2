data "archive_file" "get-long-url-redirect" {
  source_file = "services/go-link/build/getLongUrlRedirect.js"
  output_path = "services/go-link/build/getLongUrlRedirect.zip"
  type        = "zip"
}

resource "aws_lambda_function" "getLongUrlRedirect" {
  environment {
    variables = {
      TABLE       = aws_dynamodb_table.go-link-table.name
      DEFAULT_URL = "https://evon.fi"
    }
  }

  function_name    = "getLongUrlRedirect"
  filename         = "services/go-link/build/getLongUrlRedirect.zip"
  handler          = "services/go-link/build/getLongUrlRedirect.handler"
  source_code_hash = data.archive_file.get-long-url-redirect.output_base64sha256
  runtime          = "nodejs18.x"
  architectures    = ["arm64"]
  role             = aws_iam_role.iam-for-lambda.arn

  tags = {
    service = "go-link"
  }
}
