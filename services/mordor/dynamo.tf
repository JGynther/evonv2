resource "aws_dynamodb_table" "mordor-audit" {
  name         = "mordor-audit"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "eventId"
    type = "S"
  }

  hash_key = "eventId"

  tags = {
    service = "mordor"
  }
}

output "audit-table-arn" {
  value = aws_dynamodb_table.mordor-audit.arn
}
