resource "aws_instance" "test" {
    
    ami = "ami-013e83f579886baeb"
    instance_type = "t2.micro"
    key_name = "private"
    user_data = file("appsinstall.sh")

    tags = {
      
       Name = "ec2-userdata" 
    }
}