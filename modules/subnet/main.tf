resource "aws_subnet" "dev-subnet-1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.az
  tags = {
    Name = "${var.env_prefix}-subnet-1"
  }
}

resource "aws_internet_gateway" "my-app-internet-gateway" {
  vpc_id = var.vpc_id

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
  default_route_table_id = var.default_route_table_id

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
