# Lifecycle rules for cost optimization
resource "aws_s3_bucket_lifecycle_configuration" "photo_storage" {
  bucket = aws_s3_bucket.photo_storage.id

  # Lifecycle rule for public folder
  rule {
    id     = "public-folder-lifecycle"
    status = "Enabled"

    filter {
      prefix = "public/"
    }

    transition {
      days          = var.lifecycle_transition_days
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.lifecycle_glacier_days
      storage_class = "GLACIER"
    }

    noncurrent_version_transition {
      noncurrent_days = var.lifecycle_transition_days
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = var.lifecycle_glacier_days
      storage_class   = "GLACIER"
    }
  }

  # Lifecycle rule for private folder
  rule {
    id     = "private-folder-lifecycle"
    status = "Enabled"

    filter {
      prefix = "private/"
    }

    transition {
      days          = var.lifecycle_transition_days
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.lifecycle_glacier_days
      storage_class = "GLACIER"
    }

    noncurrent_version_transition {
      noncurrent_days = var.lifecycle_transition_days
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = var.lifecycle_glacier_days
      storage_class   = "GLACIER"
    }
  }

  # Cleanup incomplete multipart uploads
  rule {
    id     = "cleanup-incomplete-uploads"
    status = "Enabled"

    filter {
      prefix = ""
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
