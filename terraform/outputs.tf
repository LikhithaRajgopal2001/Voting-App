# EC2 Public IP Output (fixed name to match deploy.yml)
output "ec2_public_ip" {
  value       = aws_instance.voting_server.public_ip
  description = "The public IP address of the EC2 instance"
}

# EC2 Instance ID
output "instance_id" {
  value       = aws_instance.voting_server.id
  description = "The ID of the EC2 instance"
}

# VPC ID
output "vpc_id" {
  value       = aws_vpc.voting_vpc.id
  description = "The VPC ID for the voting application"
}

# Security Group ID
output "security_group_id" {
  value       = aws_security_group.voting_sg.id
  description = "The security group ID for the voting application"
}

# SSH Private Key
output "private_key_pem" {
  value       = tls_private_key.voting_key.private_key_pem
  description = "The private key for SSH access to the EC2 instance"
  sensitive   = true
}

# Key Pair Name
output "key_pair_name" {
  value       = aws_key_pair.voting_keypair.key_name
  description = "The name of the SSH key pair"
}
