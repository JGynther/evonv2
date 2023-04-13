resource "aws_s3_bucket" "website" {
  bucket = "osakeanti.evon.fi"
  tags = {
    service = "stock-platform"
  }
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.website.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "allow-cloudfront" {
  bucket = aws_s3_bucket.website.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "s3:GetObject",
          "Effect" : "Allow",
          "Principal" : "*",
          "Resource" : "${aws_s3_bucket.website.arn}/*"
        }
      ]
    }
  )
}
