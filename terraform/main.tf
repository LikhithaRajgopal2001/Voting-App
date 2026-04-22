# Configure AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# Generate a unique suffix for resources to avoid conflicts
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Create SSH Key Pair with unique name
resource "tls_private_key" "voting_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "voting_keypair" {
  key_name   = "voting-app-key-${random_string.suffix.result}"
  public_key = tls_private_key.voting_key.public_key_openssh

  tags = {
    Name = "voting-app-keypair-${random_string.suffix.result}"
  }
}

# Create VPC with unique name
resource "aws_vpc" "voting_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "voting-vpc-${random_string.suffix.result}"
  }
}

# Create Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.voting_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"

  tags = {
    Name = "voting-subnet-${random_string.suffix.result}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.voting_vpc.id

  tags = {
    Name = "voting-igw-${random_string.suffix.result}"
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
    Name = "voting-rt-${random_string.suffix.result}"
  }
}

# Route Table Association
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group with unique name
resource "aws_security_group" "voting_sg" {
  name        = "voting-sg-${random_string.suffix.result}"
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
    Name = "voting-sg-${random_string.suffix.result}"
  }
}

# EC2 Instance
resource "aws_instance" "voting_server" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.voting_sg.id]

  key_name = aws_key_pair.voting_keypair.key_name

  #user_data = base64encode(templatefile("${path.module}/user_data.sh", {}))

  tags = {
    Name = "voting-server-${random_string.suffix.result}"
  }

  depends_on = [
    aws_internet_gateway.igw
  ]
}
