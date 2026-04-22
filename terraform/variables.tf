# AWS Region
variable "region" {
  description = "AWS region to deploy the EC2 instance"
  type        = string
  default     = "ap-south-1"
}

# EC2 Instance Type
variable "instance_type" {
  description = "EC2 instance type (free tier)"
  type        = string
  default     = "t2.micro"
}

# AMI ID (Ubuntu 22.04 for ap-south-1)
variable "ami_id" {
  description = "Ubuntu 22.04 AMI ID for the specified region"
  type        = string
  default     = "ami-0f5ee92e2d63afc18"
}

# SSH Key Pair Name
variable "key_name" {
  description = "Name of the EC2 key pair for SSH access"
  type        = string
  default     = "voting-app-key"
}
