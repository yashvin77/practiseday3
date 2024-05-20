resource "aws_instance" "ec21" {
  ami           = var.ami_id1
  instance_type = var.instance_type1
  key_name      = var.key_name_instance1

 tags = {
      
      Name = "mye7"
    }

}
