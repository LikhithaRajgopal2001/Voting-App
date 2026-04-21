# variables.tf
variable "region" {
  description = "AWS region to deploy the EC2 instance"
  type        = string
  default     = "us-east-1"
}
variable "instance_type" {
  description = "EC2 instance type (free tier)"
  type        = string
  default     = "t2.micro"
}
variable "ami_id" {
  description = "Ubuntu 22.04 AMI ID for us-east-1"
  type        = string
  default     = "ami-0c7217cdde317cfec"
}
#variable "key_name" {
#  description = "Your EC2 key pair name to SSH into the instance"
 # type        = string
#}
