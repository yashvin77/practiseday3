terraform {
  backend "s3" {
    bucket = "tfstate-file-config"
    key    = "terraform.tsstate"
    region = "ap-south-1"
  }
}