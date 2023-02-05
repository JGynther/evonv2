resource "aws_iam_role" "iam-for-lambda" {
  name = "iam_for_lambda"
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
    service = "go-link"
  }
}

resource "aws_iam_role_policy" "dynamodb-lambda" {
  name = "dynamodb-lambda"
  role = aws_iam_role.iam-for-lambda.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "dynamodb:*",
          "Effect" : "Allow",
          "Resource" : "${aws_dynamodb_table.go-link-table.arn}"
        }
      ]
    }
  )

}
