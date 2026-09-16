resource "aws_s3_bucket" "pbl_bucket" {
  bucket_prefix = "pbl-cloud-security-"

  tags = {
    Name    = "PBL-S3-Bucket"
    Project = "Cloud-Security-PBL"
  }
}

resource "aws_s3_bucket_public_access_block" "pbl_bucket_block" {
  bucket = aws_s3_bucket.pbl_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "pbl_bucket_encryption" {
  bucket = aws_s3_bucket.pbl_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}