resource "aws_vpc" "main" {
  cidr_block = var.vpc-cidr

  tags = {
    Name = "${var.Name}"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.psubnet-cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.Name}-public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.prisubnet-cidr

  tags = {
    Name = "${var.Name}-private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id


  route {
    cidr_block = var.cidr
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-Route"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id


  route {
    cidr_block = var.cidr
    gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "private-Route"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id

  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.private.id

  route_table_id = aws_route_table.private.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "sample"
  }
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_eip" "example" {
  domain = "vpc"
}

resource "aws_security_group" "ssh" {
  name   = "allow_ssh"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}