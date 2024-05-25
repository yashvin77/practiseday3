##Created Locals for calling s3 name
locals {
   bucket-name = "tf-statefile-config"
}

#S3 bucket creation to store the state file 
resource "aws_s3_bucket" "remote" {
    bucket = local.bucket-name
  
}

#versioning enabled
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.remote.id
  versioning_configuration {
    status = "Enabled"
  }
}

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

# Create Security group with for loop

resource "aws_security_group" "devops-project-yashu" {
  name        = "devops-project-yashu"
  description = "Allow TLS inbound traffic"
  vpc_id = aws_vpc.custom_VPC.id

  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000, 8082, 8081,8083] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-project-yashu"
  }
}

# creating s3 bucket with dependency block

resource "aws_s3_bucket" "new" {
  bucket = "hgfligwyefiugfk"
  depends_on = [aws_instance.ec2]
}

# Creating data source to call existing iam role

data "aws_iam_role" "existing_role" {
  name = "admin"
  
}

# Creating an Instance profile for the iam role

resource "aws_iam_instance_profile" "policy" {
  name = "new_profile"
  role = data.aws_iam_role.existing_role.id
}

# Creating provisner for remote execution of file

#  provisioner "remote-exec" {
#     inline = [
# "touch file200",
# "echo hello from aws >> file200",
# ]
#  }

# Creating Instance 

resource "aws_instance" "ec2" {
    ami = var.mumai_ami
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = aws_subnet.custom_VPC.id
    vpc_security_group_ids = [aws_security_group.devops-project-yashu.id]
    iam_instance_profile = aws_iam_instance_profile.policy.id
    user_data = file("appsinstall.sh")
    for_each = toset(var.yashu)
    associate_public_ip_address = true
    

    tags = {
      
      Name = each.value
    }

  }

# resource "aws_instance" "us_ec2" {
#     ami = var.Us_ami
#     instance_type = var.instance_type
#     key_name = var.key_name
#     subnet_id = aws_subnet.custom_VPC.id
#     vpc_security_group_ids = [aws_security_group.devops-project-yashu.id]
#     iam_instance_profile = aws_iam_instance_profile.policy.id
#     user_data = file("appsinstall.sh")
#     for_each = toset(var.yashu)
#     associate_public_ip_address = true
#     provider = aws.america

#     tags = {
      
#       Name = each.value
#     }

#   }



# lifecycle {
#     create_before_destroy = true   
#}
