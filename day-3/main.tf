# Custom Network creation

# Custom VPC Creation
resource "aws_vpc" "custom_VPC" {
  cidr_block = "10.0.0.0/16"

  tags = {
    
  Name = "Myvpc"

  }
}
# custom Subnet Creation
resource "aws_subnet" "custom_VPC" {
    vpc_id = aws_vpc.custom_VPC.id
    cidr_block = "10.0.0.0/24"

    tags = {

        Name = "cust_subnet"
    }
}

# Create IG

resource "aws_internet_gateway" "custom_VPC" {
  
  vpc_id = aws_vpc.custom_VPC.id
  tags = {

        Name = "cust_IG"
    }
}

# Custom Route table creation
resource "aws_route_table" "custom_VPC" {

 vpc_id = aws_vpc.custom_VPC.id
route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_VPC.id
}
  
}

# subnet assosiation 
resource "aws_route_table_association" "custom_VPC" {
  route_table_id = aws_route_table.custom_VPC.id
  subnet_id = aws_subnet.custom_VPC.id
}


# security group ingress 

resource "aws_security_group" "dev" {
  name        = "allow_tls"
  vpc_id      = aws_vpc.custom_VPC.id
  tags = {
    Name = "dev_sg"
  }
 ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }


egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }


  }


  resource "aws_instance" "ec2" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = aws_subnet.custom_VPC.id
    security_groups = ["aws_security_group.dev.id"]
    tags = {
      
      Name = "myec6"
    }

  }