resource "aws_instance" "ec2" {
  
ami = "ami-013e83f579886baeb"
instance_type = "t2.micro"
key_name = "private"

 tags = {
      Name = "Newec2"
    }

}