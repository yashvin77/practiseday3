resource "aws_instance" "ec2" {

    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    for_each = toset(var.yashu)

tags = {
  
  Name = each.value

}

}