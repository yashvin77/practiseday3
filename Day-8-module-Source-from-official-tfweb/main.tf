module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type          = "t2.micro"
  key_name               = "private"
  monitoring             = true


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}