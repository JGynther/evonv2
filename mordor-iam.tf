resource "aws_iam_policy" "mordor-user-policy" {
  name = "mordor-user-policy"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "dynamodb:DescribeTable",
            "dynamodb:Query",
            "dynamodb:Scan"
          ]
          "Effect" : "Allow",
          "Resource" : "${module.stock-platform.stock-subscriptions-table.arn}"
        }
      ]
    }
  )
}
