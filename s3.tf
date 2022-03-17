provider "aws" {
    region = "us-east-1"
    access_key = "AKIAR4EI5CS6NKWGXNG3"
    secret_key = "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"
}

resource "aws_s3_bucket" "bucket1" {
  bucket = "my-first-bucket-17-03-2022"
  acl    = "private"

  tags = {
    Environment = "Dev"
  }
}