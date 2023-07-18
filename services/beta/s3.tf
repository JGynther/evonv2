resource "aws_s3_bucket" "website" {
  bucket = "evon-website"
  tags = {
    service = "beta"
  }
}

resource "aws_s3_bucket_policy" "allow-cloudfront" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.default.json
}

data "aws_iam_policy_document" "default" {
  statement {
    actions = ["s3:GetObject", "s3:ListBucket"]

    resources = ["${aws_s3_bucket.website.arn}/*", "${aws_s3_bucket.website.arn}"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.beta-cloudfront.arn]
    }
  }
}
