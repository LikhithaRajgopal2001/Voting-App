output "instance_public_ip" {
  value       = aws_instance.voting_server.public_ip
  description = "The public IP address of the EC2 instance"
}

output "instance_id" {
  value       = aws_instance.voting_server.id
  description = "The ID of the EC2 instance"
}

output "vpc_id" {
  value       = aws_vpc.voting_vpc.id
  description = "The VPC ID for the voting application"
}

output "security_group_id" {
  value       = aws_security_group.voting_sg.id
  description = "The security group ID for the voting application"
}
