resource "aws_iam_role" "lambda-beta-blog" {
  name = "lambda-beta-blog"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Effect" : "Allow",
        }
      ]
    }
  )

  tags = {
    service = "beta"
  }
}

resource "aws_iam_role_policy" "lambda-beta-blog" {
  name = "lambda-beta-blog"
  role = aws_iam_role.lambda-beta-blog.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "dynamodb:DescribeTable",
            "dynamodb:Query",
            "dynamodb:Scan",
            "dynamodb:GetItem"
          ],
          "Effect" : "Allow",
          "Resource" : [
            "${aws_dynamodb_table.blog-table.arn}",
            "${aws_dynamodb_table.author-table.arn}",
            "${aws_dynamodb_table.content-table.arn}"
          ]
        }
      ]
    }
  )
}
