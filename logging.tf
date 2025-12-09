# Enable S3 server access logging for photo storage bucket
resource "aws_s3_bucket_logging" "photo_storage" {
  bucket = aws_s3_bucket.photo_storage.id

  target_bucket = aws_s3_bucket.logging.id
  target_prefix = "access-logs/"
}

# Lifecycle rule for logging bucket to manage log retention
resource "aws_s3_bucket_lifecycle_configuration" "logging" {
  bucket = aws_s3_bucket.logging.id

  rule {
    id     = "log-retention"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
}
