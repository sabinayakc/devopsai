# Photo Storage Solution - Usage Guide

## 🎯 Quick Reference

### Bucket Structure
```
photo-storage-dev-bucket-development/
├── public/          # Publicly accessible photos
│   └── *.jpg/png   # Anyone can view these files
└── private/         # Private photos
    └── *.jpg/png   # Only account owner can access
```

### Upload Examples

#### Upload to Public Folder
```bash
# Using AWS CLI
aws s3 cp photo.jpg s3://photo-storage-dev-bucket-development/public/photo.jpg

# Public URL will be:
# https://{bucket-regional-domain}/public/photo.jpg
```

#### Upload to Private Folder
```bash
# Using AWS CLI
aws s3 cp photo.jpg s3://photo-storage-dev-bucket-development/private/photo.jpg

# Only accessible with AWS credentials
```

## 📊 Storage Lifecycle

### Timeline
- **Days 0-30:** S3 Standard storage (fast access)
- **Days 30-90:** S3 Standard-IA (lower cost, slightly slower)
- **Days 90+:** S3 Glacier (lowest cost, archival)

### Cost Estimates (< 100GB)
- **Month 1:** ~$2.30 (all in Standard)
- **Month 2:** ~$1.50 (30% in Standard-IA)
- **Month 3+:** ~$0.80 (most in Glacier)
- **Total:** Well under $50/month budget ✅

## 🔐 Access Patterns

### Public Photos
```bash
# Direct browser access
https://{bucket-regional-domain}/public/vacation-2024.jpg

# Or using AWS CLI
aws s3 cp s3://bucket-name/public/photo.jpg ./local-photo.jpg --no-sign-request
```

### Private Photos
```bash
# Requires AWS credentials
aws s3 cp s3://bucket-name/private/photo.jpg ./local-photo.jpg

# Or generate presigned URL (temporary access)
aws s3 presign s3://bucket-name/private/photo.jpg --expires-in 3600
```

## 🔄 Version Recovery

If versioning is enabled (default: true), you can recover deleted or overwritten files:

```bash
# List all versions
aws s3api list-object-versions --bucket bucket-name --prefix photo.jpg

# Restore specific version
aws s3api get-object \
  --bucket bucket-name \
  --key photo.jpg \
  --version-id {version-id} \
  restored-photo.jpg
```

## 📈 Monitoring

### Check Bucket Size
```bash
aws s3 ls s3://bucket-name --recursive --summarize | grep "Total Size"
```

### View Access Logs
```bash
aws s3 ls s3://bucket-name-logs-development/access-logs/
```

## 🛠️ Deployment Commands

### Initialize
```bash
tofu init
```

### Plan Changes
```bash
tofu plan
```

### Apply Configuration
```bash
tofu apply -auto-approve
```

### View Outputs
```bash
tofu output
tofu output -json
tofu output bucket_name
```

### Destroy Resources
```bash
tofu destroy
```

## 💡 Tips

1. **Upload in batches** - Use multipart upload for files > 100MB
2. **Tag your photos** - Add metadata for better organization
3. **Monitor costs** - Check AWS Cost Explorer monthly
4. **Backup strategy** - Versioning protects against accidental deletion
5. **Glacier retrieval** - Plan ahead (retrieval takes hours)

## ⚠️ Important Notes

- **Glacier Retrieval:** Files in Glacier require 3-5 hours for standard retrieval
- **Public Access:** Only `/public/*` files are publicly accessible
- **Costs:** Data transfer out charges apply for downloads
- **Versioning:** Old versions count toward storage costs
- **Encryption:** All files are encrypted at rest automatically

## 🔍 Troubleshooting

### Cannot Access Public File
```bash
# Check bucket policy
aws s3api get-bucket-policy --bucket bucket-name

# Verify file is in public/ prefix
aws s3 ls s3://bucket-name/public/
```

### High Storage Costs
```bash
# Check storage class distribution
aws s3api list-objects-v2 --bucket bucket-name \
  --query 'Contents[*].[Key,StorageClass,Size]' --output table

# Review lifecycle rules
aws s3api get-bucket-lifecycle-configuration --bucket bucket-name
```

### Access Denied Errors
```bash
# Verify AWS credentials
aws sts get-caller-identity

# Check bucket permissions
aws s3api get-bucket-acl --bucket bucket-name
```

## 📞 Support Resources

- AWS S3 Documentation: https://docs.aws.amazon.com/s3/
- OpenTofu Documentation: https://opentofu.org/docs/
- AWS Pricing Calculator: https://calculator.aws/
