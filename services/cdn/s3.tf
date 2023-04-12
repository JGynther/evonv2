resource "aws_s3_bucket" "cdn" {
  bucket = "evon-public-cdn"
  tags = {
    service = "cdn"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.cdn.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "allow-cloudfront" {
  bucket = aws_s3_bucket.cdn.id
  policy = data.aws_iam_policy_document.default.json
}

data "aws_iam_policy_document" "default" {
  statement {
    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.cdn.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.cdn.arn]
    }
  }
}
