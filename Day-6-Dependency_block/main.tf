resource "aws_instance" "dependency" { 
    ami = "ami-013e83f579886baeb"
    instance_type = "t2.micro"
    key_name = "private" 
    tags = { 
      Name="dependency" 
    } 
   
} 
 
resource "aws_s3_bucket" "dependency" { 
    bucket = "dependecny-s3-practice" 
    depends_on = [ aws_instance.dependency] 
   
}