provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "key" {
  key_name = "newkey"
  public_key = file("~/.ssh/id_rsa.pub")#here we need to define public key file path
}

resource "aws_instance" "ec2" {
  
    ami = "ami-0bb84b8ffd87024d8"
    instance_type = "t2.micro"
    key_name = aws_key_pair.key.key_name # here give the above generated key deatils
    tags = {

        Name = "ec2"
    }   

}