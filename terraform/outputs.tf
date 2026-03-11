output "instance_public_ip" {
  value = aws_instance.voting_server.public_ip
}

output "instance_id" {
  value = aws_instance.voting_server.id
}