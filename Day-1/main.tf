resource "aws_instance" "test_ec2" {
 ami = "ami-013e83f579886baeb"
 instance_type = "t2.micro"
 key_name = "publicec2key"


 tags = {
    Name = "Myec28"
 }


 }

 resource "aws_s3_bucket" "name" {
   bucket = "dasdasv"
}