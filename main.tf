provider "aws" {
  region = "us-west-2"
}

variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "az" {}
variable "env_prefix" {}

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

resource "aws_route_table" "my-app-route-table" {
  vpc_id = aws_vpc.my-app-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-app-internet-gateway.id
  }

  tags = {
    Name = "${var.env_prefix}:my-app-vpc/rtb"
  }
}

