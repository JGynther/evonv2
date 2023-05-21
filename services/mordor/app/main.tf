resource "aws_s3_bucket" "website" {
  bucket = "mordor.evon.fi"
  tags = {
    service = "mordor"
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

resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  depends_on = [aws_s3_bucket_public_access_block.block, aws_s3_bucket_ownership_controls.ownership]
  bucket     = aws_s3_bucket.website.id
  acl        = "public-read"
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

output "mordor-website" {
  value = aws_s3_bucket_website_configuration.website
}
