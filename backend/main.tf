##4bucket
provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    region         = "eu-central-1"
    bucket         = "my-tform-state"
    key            = "backend/terraform.tfstate"
    dynamodb_table = "my-tform-lock"
    encrypt        = true
  }
}


resource "aws_s3_bucket" "my-tform-state" {
  bucket              = var.state_bucket
  object_lock_enabled = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_acl" "my-tform-state" {
  bucket = aws_s3_bucket.my-tform-state.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "s3_access_block" {
  bucket                  = aws_s3_bucket.my-tform-state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.my-tform-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.my-tform-state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_object_lock_configuration" "lock" {
  bucket              = aws_s3_bucket.my-tform-state.id
  object_lock_enabled = "Enabled"
}

resource "aws_dynamodb_table" "my-tform-lock" {
  name         = var.dynamodb_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
##4bucket
