# Create an S3 bucket for hosting a static website
resource "aws_s3_bucket" "resume_website_bucket" {
  bucket        = var.website_bucket
  force_destroy = var.force_destroy

  tags = {
    Name = "S3 bucket for ${var.website_bucket}"
  }
}
# Enable versioning on the S3 bucket if specified
resource "aws_s3_bucket_versioning" "resume_website_versioning" {
  bucket = aws_s3_bucket.resume_website_bucket.id

  versioning_configuration {
    status = var.enable_versioning
  }
}

# Configure the S3 bucket for static website hosting
resource "aws_s3_bucket_website_configuration" "s3_resume_website_configuration" {
  bucket = aws_s3_bucket.resume_website_bucket.id

  index_document {
    suffix = var.index_document_suffix
  }
}

# Configure public access settings to allow website access
resource "aws_s3_bucket_public_access_block" "website_bucket_public_access" {
  bucket = aws_s3_bucket.resume_website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Set the bucket policy to allow public read access to the website content
resource "aws_s3_bucket_policy" "resume_website_bucket_policy" {
  bucket = aws_s3_bucket.resume_website_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = ["s3:GetObject"],
        Effect    = "Allow",
        Resource  = ["${aws_s3_bucket.resume_website_bucket.arn}/*"],
        Principal = { AWS = "*" },
      },
    ]
  })

  #Set dependency to ensure public access block is created first
  depends_on = [aws_s3_bucket_public_access_block.website_bucket_public_access]
}
