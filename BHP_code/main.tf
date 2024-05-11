# Bastion Host process 

# Creating VPC 

resource "aws_vpc" "VPC" {
   cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "main"
  }
}

# Creating Public Subnet

resource "aws_subnet" "PU" {
  vpc_id     =  aws_vpc.VPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "PU"
  }
}

# Craeting Private Subnet

resource "aws_subnet" "PR" {
  
  vpc_id     =  aws_vpc.VPC.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "PR"
  }
  
}

# Creating IG

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "IGW"
  }
}

# Creating Route tale for PU Instance

resource "aws_route_table" "RT" {

vpc_id = aws_vpc.VPC.id

route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  
}


tags = {
    Name = "PURT"
  }

}

# Route table attachment 

resource "aws_route_table_association" "RTA" {
  subnet_id      = aws_subnet.PU.id
  route_table_id = aws_route_table.RT.id
}

# Creating Security group for Pu Instnace

resource "aws_security_group" "SG" {
  name        = "allow_tls"
  vpc_id      = aws_vpc.VPC.id
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

# Creating Elastic IP

resource "aws_eip" "EIP" {
  domain   = "vpc"
}


# Creating NAT Gateway

  resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.EIP.id
  subnet_id     = aws_subnet.PU.id

  tags = {
    Name = "gw NAT"
  }

  }

# Creating Public EC2 Instance with Pulic IP address 

resource "aws_instance" "ec2" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = aws_subnet.PU.id
    vpc_security_group_ids = [aws_security_group.SG.id]
    associate_public_ip_address = true
    
    tags = {
      
      Name = "Pu"
    }

  }

  # Creating Route tale for Private Instance and attach to NAT

resource "aws_route_table" "PVRT" {

vpc_id = aws_vpc.VPC.id

route {

    cidr_block = "0.0.0.0/0"
     nat_gateway_id = aws_nat_gateway.nat.id
  
}

tags = {
    Name = "PVRT"
  }

}

# Private Route table attachment 

resource "aws_route_table_association" "PVRTA" {
  subnet_id      = aws_subnet.PR.id
  route_table_id = aws_route_table.PVRT.id
}

# Creating Private EC2 Instance without IP address 

resource "aws_instance" "ec23" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = aws_subnet.PR.id
    vpc_security_group_ids = [aws_security_group.SG.id]

    
    tags = {
      
      Name = "Pr"
    }

  }