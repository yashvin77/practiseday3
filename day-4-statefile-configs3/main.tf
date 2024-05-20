#S3 bucket creation to store the state file 
resource "aws_s3_bucket" "remote" {
    bucket = "tfstate-file-config"
  
}

#versioning enabled
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.remote.id
  versioning_configuration {
    status = "Enabled"
  }
}