resource "aws_dynamodb_table" "blog-table" {
  name         = "blog"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }

  hash_key = "id"

  tags = {
    service = "beta"
  }
}

resource "aws_dynamodb_table" "author-table" {
  name         = "author"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }

  hash_key = "id"

  tags = {
    service = "beta"
  }
}