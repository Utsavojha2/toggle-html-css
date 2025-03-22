resource "aws_s3_bucket" "webbucket" {
  bucket = "my-tf-web-bucket-19999"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "website_security_configs" {
  bucket = aws_s3_bucket.webbucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.webbucket.id
  depends_on = [aws_s3_bucket.webbucket]

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.webbucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.webbucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.webbucket.id
  key    = "index.html"
  source = "../index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "styles_file" {
  bucket = aws_s3_bucket.webbucket.id
  key    = "style.css"
  source = "../style.css"
  content_type = "text/css"
}

resource "aws_s3_object" "error_html_file" {
  bucket = aws_s3_bucket.webbucket.id
  key    = "error.html"
  source = "../error.html"
  content_type = "text/html"
}