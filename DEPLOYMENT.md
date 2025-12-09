# Deployment Guide

## Quick Start

This infrastructure creates an AWS S3 bucket named `love-bro-metronet-Development` configured for Excel sheets storage.

### Prerequisites
- OpenTofu/Terraform >= 1.6.0
- AWS credentials configured (via environment variables or AWS CLI)
- Appropriate AWS permissions to create S3 resources

### Environment Variables Required
Set the following AWS credentials:
```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_REGION="us-east-1"
```

### Deployment Steps

1. **Initialize:**
   ```bash
   tofu init
   ```

2. **Validate:**
   ```bash
   tofu validate
   ```

3. **Plan:**
   ```bash
   tofu plan -var-file="terraform.tfvars.example"
   ```

4. **Apply:**
   ```bash
   tofu apply -var-file="terraform.tfvars.example"
   ```

### Expected Resources

The following resources will be created:

1. **S3 Bucket**: `love-bro-metronet-Development`
2. **Versioning**: Enabled
3. **Encryption**: AES256 (SSE-S3)
4. **Public Access Block**: All public access blocked
5. **Ownership Controls**: BucketOwnerEnforced
6. **Lifecycle Rules**:
   - Transition to Standard-IA after 30 days
   - Transition to Glacier after 90 days
   - Cleanup incomplete multipart uploads after 7 days

### Outputs

After successful deployment, you'll receive:
- `bucket_name`: Full bucket name
- `bucket_arn`: Bucket ARN
- `bucket_region`: Bucket region
- `bucket_domain_name`: Bucket domain name
- `bucket_regional_domain_name`: Regional domain name

### Cost Estimate

- **Storage**: Pay-as-you-go based on usage
- **Lifecycle transitions**: Automatic cost optimization
  - Standard-IA: ~50% cheaper than Standard
  - Glacier: ~80% cheaper than Standard
- **Requests**: Standard S3 pricing applies

### Clean Up

To destroy all resources:
```bash
tofu destroy -var-file="terraform.tfvars.example"
```

**⚠️ Warning**: This will permanently delete the bucket and all contents!

### Troubleshooting

**Issue**: Bucket name already exists
- **Solution**: S3 bucket names must be globally unique. Change `s3_bucket_name` in your tfvars file.

**Issue**: Access denied errors
- **Solution**: Ensure your AWS credentials have the necessary IAM permissions for S3.

**Issue**: Region mismatch
- **Solution**: Verify `aws_region` matches your AWS CLI/credential configuration.
