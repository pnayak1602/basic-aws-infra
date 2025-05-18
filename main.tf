# Provider to be configured via aws configure cmd in aws cli 
provider "aws" {
    profile = "vs-code-user"
    region = "us-east-1"
}

# Create a VPC in a region 
resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr_range
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

# Public subnet 
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_cidr_range

  tags = {
    Name = "my-first-public-subnet"
  }
}

# Private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_cidr_range

  tags = {
    Name = "my-first-private-subnet"
  }
}

# Key pair for SSHing into the public ec2 instance
# resource "aws_key_pair" "ec2_ssh_key_pair" {
#   key_name   = "ssh_key_pair_for_ec2"
#   public_key = file("./ssh_key_pair_for_ec2.pem") 
# }


# EC2 in public subnet
resource "aws_instance" "my_public_ec2" {
  ami           = var.ec2_ami_name
  instance_type = var.ec2_instance_type
  subnet_id = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name = "ec2_ssh" # The key pair was created manually via aws console
  #Script to be run when the ec2 instance is first launched
  user_data = <<-EOF
              #!/bin/bash -ex
              amazon-linux-extras install nginx1 -y
              echo "<h1>This is my new server - nprati :)</h1>" > /usr/share/nginx/html/index.html
              systemctl enable nginx
              systemctl start nginx
              EOF

  tags = {
    Name = "My-ec2-instance"
  }
}

#Security group config for EC2
resource "aws_security_group" "ec2_sg" {
  name        = "allow_ssh"
  description = "Allow SSH and http inbound traffic in port 22"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    Name = "allow_ssh_http"
  }
}

# Ingress rule (SSH allowed)
resource "aws_vpc_security_group_ingress_rule" "ssh_sg_ingress_rule" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Ingress rule (HTTP allowed)
resource "aws_vpc_security_group_ingress_rule" "http_sg_ingress_rule" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Ingress rule (HTTPS allowed)
resource "aws_vpc_security_group_ingress_rule" "https_sg_ingress_rule" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# Egress rule to allow all traffic outside from any port to any port
# This was needed for fetching and updating packages via https yum commands
resource "aws_vpc_security_group_egress_rule" "sg_egress_rule" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "-1"
  to_port           = 0
}


# Route table containing internet gateway route for public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0" #packet with ANY dest. 
    gateway_id = aws_internet_gateway.igw.id #next hop to igw
  }
}

# Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "My-first-internet-gateway"
  }
}

# Association of public subnet to route table
resource "aws_route_table_association" "public_subnet_to_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}