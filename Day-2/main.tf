resource "aws_instance" "ec21" {
  ami           = var.ami_id1
  instance_type = var.instance_type1
  key_name      = var.key_name_instance1
  tags = {
    Name = "MYec21"
  }
}

resource "aws_instance" "ec22" {
  ami           = var.ami_id2
  instance_type = var.instance_type2
  key_name      = var.key_name_instance2
  tags = {
    Name = "MYec22"
  }
}