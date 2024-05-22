provider "aws" {
 
}

resource "aws_instance" "test" {
  
   ami = var.ami
   instance_type = var.instance_type
   key_name = var.key_name
   count = length(var.yash)

tags = {

Name = var.yash[count.index]

}

}