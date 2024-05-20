# Creating VPC

resource "aws_vpc" "VPC" {
   cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "main"
  }
}

# Create IG

resource "aws_internet_gateway" "custom_VPC" {
  
  vpc_id = aws_vpc.VPC.id
  tags = {

        Name = "cust_IG"
    }
}

# Custom Route table creation
resource "aws_route_table" "custom_VPC" {

 vpc_id = aws_vpc.VPC.id
route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_VPC.id
}
  
}

# subnet assosiation 
resource "aws_route_table_association" "custom_VPC" {
  route_table_id = aws_route_table.custom_VPC.id
  subnet_id = aws_subnet.S1.id
}


# Creating subnet1

 resource "aws_subnet" "S1" {

    vpc_id = aws_vpc.VPC.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1a"
     tags = {

        Name = "AZ1a"
     }
 }

# Creating subnet2

 resource "aws_subnet" "S2" {

    vpc_id = aws_vpc.VPC.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "ap-south-1b"
     tags = {

        Name = "AZ1b"
     }
 }

# # Creating security group

resource "aws_security_group" "dev" {
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

# Creating Instance

resource "aws_instance" "EC2" {
    ami = "ami-013e83f579886baeb"
    instance_type = "t2.micro"
    key_name = "private"
    associate_public_ip_address = true
    vpc_security_group_ids = [ aws_security_group.dev.id ]
    subnet_id = aws_subnet.S1.id
    

    tags = {
      
      Name = "tests"
    
}

}

# Craeting AMI

resource "aws_ami_from_instance" "testss" {
  name               = "testss"
  source_instance_id = aws_instance.EC2.id
}

# Creating launch template

resource "aws_launch_template" "test_template" {
   image_id = aws_ami_from_instance.testss.id
   instance_type = "t2.micro"
   key_name = "private"
}

# Craeting Target Group

resource "aws_lb_target_group" "test" {
  name     = "Test"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.VPC.id
}

# Creating application load balancer

resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.dev.id]
  subnets            = [aws_subnet.S1.id, aws_subnet.S2.id ]
  tags = {
    Name = "test"
  }
}

# Attaching target group

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.EC2.id
  port             = 80
}

# Auto scalling Group Creation

resource "aws_autoscaling_group" "bar" {
  name                      = "test"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.S1.id, aws_subnet.S2.id]
  launch_template {
    id      = aws_launch_template.test_template.id
    version = "$Latest"
  }
}
