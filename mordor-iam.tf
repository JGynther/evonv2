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
            "dynamodb:Scan",
            "dynamodb:GetItem",
            "dynamodb:UpdateItem",
            "dynamodb:PutItem"
          ],
          "Effect" : "Allow",
          "Resource" : [module.beta.blog-table-arn, module.beta.author-table-arn]
        },
        {
          "Action" : [
            "dynamodb:PutItem"
          ]
          "Effect" : "Allow",
          "Resource" : [module.mordor.audit-table-arn]
        }
      ]
    }
  )
}
