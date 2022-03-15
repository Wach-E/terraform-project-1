provider "aws" {
  region = "us-west-2"
}

variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "az" {}
variable "env_prefix" {}
variable "ip_address_range" {}  # eg myIP/32

resource "aws_vpc" "my-app-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id            = aws_vpc.my-app-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.az
  tags = {
    Name = "${var.env_prefix}-subnet-1"
  }
}

resource "aws_internet_gateway" "my-app-internet-gateway" {
  vpc_id = aws_vpc.my-app-vpc.id

  tags = {
    Name = "${var.env_prefix}:my-app-vpc/igw"
  }
}

# Use custom route table
# resource "aws_route_table" "my-app-route-table" {
#   vpc_id = aws_vpc.my-app-vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.my-app-internet-gateway.id
#   }

#   tags = {
#     Name = "${var.env_prefix}:my-app-vpc/rtb"
#   }
# }

# resource "aws_route_table_association" "my-app-route-table-association" {
#   subnet_id = aws_subnet.dev-subnet-1.id
#   route_table_id = aws_route_table.my-app-route-table.id
# }

resource "aws_default_route_table" "my-app-default-route-table" {
  default_route_table_id = aws_vpc.my-app-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-app-internet-gateway.id
  }

  tags = {
    Name = "${var.env_prefix}:my-app-vpc/default-rtb"
  }
}
# When using default route table, this happens behind the hood so, we don't need to explicitly specify it.
# resource "aws_route_table_association" "my-app-default-route-table-association" {
#   subnet_id = aws_subnet.dev-subnet-1.id
#   route_table_id = aws_default_route_table.my-app-default-route-table.id
# }

resource "aws_security_group" "my-app-sg" {
  name = "my-app-sg"
  vpc_id = aws_vpc.my-app-vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.ip_address_range]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.env_prefix}:my-app-vpc/sg"
  }
}