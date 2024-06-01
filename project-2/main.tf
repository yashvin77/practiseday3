resource "aws_instance" "multiple_instances" {
  ami           = "ami-013e83f579886baeb"
  instance_type = each.value.instance_type
  key_name      = each.value.key_name
  for_each      =  var.instances

  tags = {
    Name = "${each.key}-${each.value.key_name}"
  }
}