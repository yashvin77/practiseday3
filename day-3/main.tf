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

# security group creation
resource "aws_security_group" "custom_VPC" {
 
  vpc_id = aws_vpc.custom_VPC.id
  name = "cust-sg"

}

# security group ingress 

resource "aws_vpc_security_group_ingress_rule" "custom_VPC" {

    security_group_id = aws_security_group.custom_VPC.id
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "cus" {

    security_group_id = aws_security_group.custom_VPC.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "cust" {

    security_group_id = aws_security_group.custom_VPC.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  cidr_ipv4 = "0.0.0.0/0"
}

# security group outbound

resource "aws_vpc_security_group_egress_rule" "cu" {

    security_group_id = aws_security_group.custom_VPC.id
  
     ip_protocol = "-1"
    cidr_ipv4 = "0.0.0.0/0"
  
}

  resource "aws_instance" "ec2" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = aws_subnet.custom_VPC.id
    security_groups = [aws_security_group.custom_VPC.id]

    tags = {
      
      Name = "myec7"
    }

  }