module "listAllBlogs" {
  source  = "../../../lib/modules/lambda-apigw"
  name    = "listAllBlogs"
  path    = "services/beta/backend"
  iam     = aws_iam_role.lambda-beta-blog
  service = "beta"
  apigw   = aws_apigatewayv2_api.beta-apigw
  route   = "GET /api/blog"
  env = {
    TABLE = aws_dynamodb_table.blog-table.name
  }
}

module "getBlogById" {
  source  = "../../../lib/modules/lambda-apigw"
  name    = "getBlogById"
  path    = "services/beta/backend"
  iam     = aws_iam_role.lambda-beta-blog
  service = "beta"
  apigw   = aws_apigatewayv2_api.beta-apigw
  route   = "GET /api/blog/{id}"
  env = {
    TABLE = aws_dynamodb_table.blog-table.name
  }
}

module "getAuthorById" {
  source  = "../../../lib/modules/lambda-apigw"
  name    = "getAuthorById"
  path    = "services/beta/backend"
  iam     = aws_iam_role.lambda-beta-blog
  service = "beta"
  apigw   = aws_apigatewayv2_api.beta-apigw
  route   = "GET /api/author/{id}"
  env = {
    TABLE = aws_dynamodb_table.author-table.name
  }
}
