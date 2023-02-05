resource "aws_dynamodb_table" "go-link-table" {
  name         = "go-link"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "shortid"
    type = "S"
  }

  hash_key = "shortid"

  tags = {
    service = "go-link"
  }
}
