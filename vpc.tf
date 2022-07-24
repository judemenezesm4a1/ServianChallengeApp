### Virtual Private Cloud ###
resource "aws_default_vpc" "default_vpc" {
  
}

# Subnets in VPC, 3 subnets in 3 availability zone
resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "ap-southeast-2a"
}

resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = "ap-southeast-2b"
}

resource "aws_default_subnet" "default_subnet_c" {
  availability_zone = "ap-southeast-2c"
}