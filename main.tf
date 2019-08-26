# This is a tf module for managing the s3 bucket and dynamodb table for the terraform state store.
# The state for this tf should be stored in git.

resource "aws_s3_bucket" "terraform" {
  bucket = var.s3_bucket

  tags = {
    Name        = var.s3_bucket_name
    Environment = var.env
  }

  # Enable versioning so we can see the full revision history of our state files
  versioning {
    enabled = true
  }
  
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform" {
  name         = var.dynamodb_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
