locals {
   bucket-name = "${var.acd}${var.efg}-yaswanth"
}

resource "aws_s3_bucket" "sample" {
  
bucket = local.bucket-name

tags = {
  Name = local.bucket-name
}

}