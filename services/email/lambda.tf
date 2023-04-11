data "archive_file" "sendSingleEmail" {
  source_file = "services/email/build/sendSingleEmail.js"
  output_path = "services/email/build/sendSingleEmail.zip"
  type        = "zip"
}

resource "aws_lambda_function" "sendSingleEmail" {
  function_name    = "sendSingleEmail"
  filename         = "services/email/build/sendSingleEmail.zip"
  handler          = "services/email/build/sendSingleEmail.handler"
  source_code_hash = data.archive_file.sendSingleEmail.output_base64sha256
  runtime          = "nodejs18.x"
  architectures    = ["arm64"]
  role             = aws_iam_role.lambda-email.arn
  tags = {
    service = "email"
  }
}
