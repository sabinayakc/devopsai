# Public access block configuration - allow selective public access
resource "aws_s3_bucket_public_access_block" "photo_storage" {
  bucket = aws_s3_bucket.photo_storage.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Block all public access for logging bucket
resource "aws_s3_bucket_public_access_block" "logging" {
  bucket = aws_s3_bucket.logging.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ACL for photo storage bucket
resource "aws_s3_bucket_acl" "photo_storage" {
  depends_on = [
    aws_s3_bucket_ownership_controls.photo_storage,
    aws_s3_bucket_public_access_block.photo_storage
  ]

  bucket = aws_s3_bucket.photo_storage.id
  acl    = "private"
}

# ACL for logging bucket
resource "aws_s3_bucket_acl" "logging" {
  depends_on = [
    aws_s3_bucket_ownership_controls.logging,
    aws_s3_bucket_public_access_block.logging
  ]

  bucket = aws_s3_bucket.logging.id
  acl    = "log-delivery-write"
}

# Bucket policy for selective public access
resource "aws_s3_bucket_policy" "photo_storage" {
  depends_on = [
    aws_s3_bucket_public_access_block.photo_storage
  ]

  bucket = aws_s3_bucket.photo_storage.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.photo_storage.arn}/public/*"
      },
      {
        Sid       = "DenyPublicAccessToPrivate"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.photo_storage.arn}/private/*"
        Condition = {
          StringNotEquals = {
            "aws:PrincipalAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}
