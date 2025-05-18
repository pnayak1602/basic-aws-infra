output vpc_arn {
  value       = aws_vpc.my_vpc.arn
}

output public_subnet_az {
    value = aws_subnet.public_subnet.availability_zone
}

output private_subnet_az {
    value = aws_subnet.private_subnet.availability_zone
}

output public_subnet_ec2 {
    value = aws_instance.my_public_ec2
}

