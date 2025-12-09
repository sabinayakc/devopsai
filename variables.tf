variable "environment" {
  description = "Environment name for resource naming and tagging"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "s3_enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
}

variable "s3_encryption_type" {
  description = "Server-side encryption algorithm to use (AES256 or aws:kms)"
  type        = string
}

variable "s3_block_public_access" {
  description = "Enable blocking of public access to the S3 bucket"
  type        = bool
}

variable "s3_lifecycle_enabled" {
  description = "Enable lifecycle rules for the S3 bucket"
  type        = bool
}

variable "s3_lifecycle_rules" {
  description = "Lifecycle rules configuration for object transitions"
  type = object({
    transition_to_ia_days      = number
    transition_to_glacier_days = number
    expiration_days            = number
  })
}

variable "s3_bucket_tags" {
  description = "Tags to apply to the S3 bucket"
  type        = map(string)
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
}
