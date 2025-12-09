# AWS S3 Bucket Infrastructure

This infrastructure code provisions an AWS S3 bucket configured for Excel sheets storage with enterprise-grade security and cost optimization features.

## Features

- **Versioning**: Enabled for data protection and recovery
- **Encryption**: Server-side encryption using AES256 (Amazon S3-managed keys)
- **Access Control**: Private bucket with all public access blocked
- **Lifecycle Management**: Automated tiering to reduce storage costs
  - Standard-IA after 30 days
  - Glacier after 90 days
- **Ownership Controls**: BucketOwnerEnforced for simplified access management
- **Multipart Upload Cleanup**: Automatic cleanup of incomplete uploads after 7 days

## Prerequisites

- OpenTofu/Terraform >= 1.6.0
- AWS CLI configured with appropriate credentials
- AWS account with permissions to create S3 resources

## Usage

1. **Initialize the configuration:**
   ```bash
   tofu init
   ```

2. **Create a `terraform.tfvars` file:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
   
   Edit the values as needed for your environment.

3. **Review the execution plan:**
   ```bash
   tofu plan
   ```

4. **Apply the configuration:**
   ```bash
   tofu apply
   ```

5. **View outputs:**
   ```bash
   tofu output
   ```

## Configuration Variables

| Variable | Description | Type | Required |
|----------|-------------|------|----------|
| `environment` | Environment name | string | Yes |
| `s3_bucket_name` | S3 bucket base name | string | Yes |
| `s3_enable_versioning` | Enable bucket versioning | bool | Yes |
| `s3_encryption_type` | Encryption algorithm (AES256 or aws:kms) | string | Yes |
| `s3_block_public_access` | Block all public access | bool | Yes |
| `s3_lifecycle_enabled` | Enable lifecycle rules | bool | Yes |
| `s3_lifecycle_rules` | Lifecycle transition rules | object | Yes |
| `s3_bucket_tags` | Resource tags | map(string) | Yes |
| `aws_region` | AWS region | string | Yes |

## Outputs

| Output | Description |
|--------|-------------|
| `bucket_name` | The name of the S3 bucket |
| `bucket_arn` | The ARN of the S3 bucket |
| `bucket_region` | The AWS region of the bucket |
| `bucket_domain_name` | The bucket domain name |
| `bucket_regional_domain_name` | The bucket regional domain name |

## Security Considerations

- All public access is blocked by default
- Server-side encryption is enforced
- Bucket ownership controls are set to BucketOwnerEnforced
- AWS provider uses environment variables for authentication (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)

## Cost Optimization

The lifecycle rules automatically transition objects to lower-cost storage classes:
- **Standard-IA**: After 30 days (60% cost reduction)
- **Glacier**: After 90 days (80% cost reduction)

## Maintenance

To destroy the infrastructure:
```bash
tofu destroy
```

**Warning**: This will delete the S3 bucket and all its contents. Ensure you have backups if needed.

## Support

For issues or questions, please refer to the AWS S3 documentation or OpenTofu documentation.
