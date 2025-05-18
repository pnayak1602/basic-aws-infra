variable vpc_cidr_range {
  type        = string
  default     = ""
  description = "CIDR raange for my VPC"
}

variable vpc_name {
  type        = string
  default     = ""
  description = "name of my VPC"
}

variable public_subnet_cidr_range {
  type        = string
  default     = ""
  description = "CIDR range for public subnet"
}

variable private_subnet_cidr_range {
  type        = string
  default     = ""
  description = "CIDR range for private subnet"
}

variable ec2_instance_type {
  type        = string
  default     = "t2.micro"
  description = "EC2 instance type"
}

variable ec2_ami_name {
  type        = string
  default     = "ami-007868005aea67c54"
  description = "EC2 AMI name"
}

