resource "aws_dynamodb_table" "stock-offerings" {
  name         = "stock-offerings"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }

  hash_key = "id"

  tags = {
    service = "stock-platform"
  }
}

resource "aws_dynamodb_table" "stock-subscriptions" {
  name         = "stock-subscriptions"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "email"
    type = "S"
  }

  hash_key  = "id"
  range_key = "email"

  tags = {
    service = "stock-platform"
  }
}

output "stock-subscriptions-table" {
  value = aws_dynamodb_table.stock-subscriptions
}
