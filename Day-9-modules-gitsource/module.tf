module "sample" {
  source = "github.com/yashvin77/practiseday3/Day-8-modules-ec2-template"
  ami_id1 = "ami-013e83f579886baeb"
  instance_type1     = "t2.micro"
  key_name_instance1 = "private"
}