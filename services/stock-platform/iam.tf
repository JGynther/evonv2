resource "aws_iam_role" "lambda-stock-offerings" {
  name = "lambda-stock-offerings"
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
    service = "stock-platform"
  }
}

resource "aws_iam_role_policy" "lambda-stock-offerings-dynamodb" {
  name = "dynamodb-lambda"
  role = aws_iam_role.lambda-stock-offerings.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "dynamodb:*",
          "Effect" : "Allow",
          "Resource" : "${aws_dynamodb_table.stock-offerings.arn}"
        }
      ]
    }
  )
}

resource "aws_iam_role" "lambda-subscribe" {
  name = "lambda-subscribe"
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
    service = "stock-platform"
  }
}

variable "email-lambda-arn" {}
resource "aws_iam_role_policy" "lambda-subscribe" {
  name = "lambda-subscribe"
  role = aws_iam_role.lambda-subscribe.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "dynamodb:*",
          "Effect" : "Allow",
          "Resource" : ["${aws_dynamodb_table.stock-offerings.arn}", "${aws_dynamodb_table.stock-subscriptions.arn}"]
        },
        {
          "Action" : "lambda:InvokeFunction",
          "Effect" : "Allow",
          "Resource" : "${var.email-lambda-arn}"
        }
      ]
    }
  )
}
