# Configure AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#provider "aws" {
 # region = var.region
#}

# Create SSH Key Pair
resource "tls_private_key" "voting_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "voting_keypair" {
  key_name   = var.key_name
  public_key = tls_private_key.voting_key.public_key_openssh
}

# Create VPC
resource "aws_vpc" "voting_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "voting-app-vpc"
  }
}

# Create Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.voting_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"

  tags = {
    Name = "voting-public-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.voting_vpc.id

  tags = {
    Name = "voting-igw"
  }
}

# Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.voting_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "voting-public-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group
resource "aws_security_group" "voting_sg" {
  name        = "voting-app-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.voting_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Voting App"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Results App"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "voting-app-sg"
  }
}

# EC2 Instance
resource "aws_instance" "voting_server" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.voting_sg.id]

  key_name = aws_key_pair.voting_keypair.key_name

  tags = {
    Name = "voting-app-server"
  }
}
