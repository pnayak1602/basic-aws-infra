This repository is for creating a basic AWS-infra. It creates the following: 
1. A VPC 
2. A public and pricate subnet 
3. An EC2 instance in public subnet which can be SSHed into from anywhere
4. Security group for SSH enabling in the public EC2 instance 
5. A route table for the public subnet
6. Internet gateway for accessing outside info from the VPC


The following is coming up: 
1. Adding an EC2 instance in the private subnet 
2. Allowing the private EC2 instance to access outside info, but do not allow access from outside to the private instance