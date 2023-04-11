resource "aws_iam_role" "lambda-email" {
  name = "lambda-email"
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
    service = "email"
  }
}

resource "aws_iam_role_policy" "lambda-email" {
  name = "lambda-email"
  role = aws_iam_role.lambda-email.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : ["ses:SendEmail", "ses:SendRawEmail"],
          "Effect" : "Allow",
          "Resource" : "*"
        }
      ]
    }
  )
}
