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

resource "aws_dynamodb_table" "content-table" {
  name         = "content"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "slug"
    type = "S"
  }

  hash_key = "slug"

  tags = {
    service = "beta"
  }
}

output "content-table-arn" {
  value = aws_dynamodb_table.content-table.arn
}

output "author-table-arn" {
  value = aws_dynamodb_table.author-table.arn
}

output "blog-table-arn" {
  value = aws_dynamodb_table.blog-table.arn
}
