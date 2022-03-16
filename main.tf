provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "my-app-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

module "my-app-subnet" {
  source                 = "./modules/subnet/"
  vpc_id                 = aws_vpc.my-app-vpc.id
  subnet_cidr_block      = var.subnet_cidr_block
  az                     = var.az
  env_prefix             = var.env_prefix
  default_route_table_id = aws_vpc.my-app-vpc.default_route_table_id
  ip_address_range       = var.ip_address_range
}