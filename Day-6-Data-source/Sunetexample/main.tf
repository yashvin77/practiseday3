provider "aws" { 
       
} 
data "aws_subnet" "selected" { 
  filter { 
    name   = "tag:Name" 
    values = ["Subnet_1"] 
  } 
} 
 
resource "aws_instance" "dependency" { 
    ami = "ami-013e83f579886baeb" 
    instance_type = "t2.micro" 
    key_name = "private" 
    subnet_id = data.aws_subnet.selected.id 
    tags = { 
      Name="datasource" 
    } 
   
}